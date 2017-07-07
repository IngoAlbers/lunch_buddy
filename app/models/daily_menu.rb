class DailyMenu < ApplicationRecord
  before_validation :set_content

  scope :of_today, -> { where(date: Date.today.beginning_of_day) }

  RESTAURANTS = ['Lilly Jo'].freeze

  validates :date, :restaurant, :content, presence: true
  validates :restaurant, inclusion: { in: DailyMenu::RESTAURANTS }

  def broadcast
    message = "*Heute (#{date.strftime('%F')}) im #{restaurant}:*\n"
    message << content

    @client ||= SlackClient.new
    @client.chat_postMessage(channel: '#lunchtime', text: message, as_user: true)
  end

  def self.broadcast
    of_today.each(&:broadcast)
  end

  def self.gather
    RESTAURANTS.each do |restaurant|
      DailyMenu.create(restaurant: restaurant, date: Date.today)
    end
  end

  private

  def set_content
    require 'open-uri'

    date = self.date
    week = date.strftime('%W')

    io = open("https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-#{week}.pdf")
    reader = PDF::Reader.new(io)

    self.content = get_daily_menu(reader, date)
  end

  def get_daily_menu(reader, date)
    actual_text = get_actual_text(reader)
    get_content(actual_text, date).strip
  end

  def get_actual_text(reader)
    str = reader.objects.values.select { |v| v.class == Hash }.map { |v| v[:ActualText] }
    sanitize(str.join)
  end

  def get_content(str, date)
    date_start = formatted_date(date)
    date_end = formatted_date(date + 1.day)

    if date_start == 'Freitag'
      str[/#{date_start}(.*)/, 1]
    else
      str[/#{date_start}(.*?)#{date_end}/, 1]
    end
  end

  def sanitize(str)
    str = str.force_encoding('ASCII-8BIT')
             .gsub(/#{"\x00|\xFE|\xFF".force_encoding("ASCII-8BIT")}/, '')
             .gsub(/#{"\xE4".force_encoding("ASCII-8BIT")}/, 'aaee')
             .gsub(/#{"\xF6".force_encoding("ASCII-8BIT")}/, 'ooee')
             .gsub(/#{"\xFC".force_encoding("ASCII-8BIT")}/, 'uuee')
             .gsub(/#{"\xE9".force_encoding("ASCII-8BIT")}/, 'e')

    # Workaround to make sure 'sauer' doesn't turn to 'saür'
    str.gsub('aaee', 'ä')
       .gsub('ooee', 'ö')
       .gsub('uuee', 'ü')
  end

  def formatted_date(date)
    I18n.l(date, format: '%A', locale: :de)
  end
end
