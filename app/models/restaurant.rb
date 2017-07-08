class Restaurant < ApplicationRecord
  has_many :daily_menus

  validates :name, presence: true

  def get_daily_menu(date = Date.today)
    return unless content = set_content(date)

    daily_menus.create(date: date, content: content)
  end

  def self.get_daily_menus
    all.each(&:get_daily_menu)
  end

  private

  def set_content(date)
    require 'open-uri'

    week = date.strftime('%W')
    io = open("https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-#{week}.pdf")
    reader = PDF::Reader.new(io)

    get_bla(reader, date)
  end

  def get_bla(reader, date)
    actual_text = get_actual_text(reader)
    get_content(actual_text, date)&.strip
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
