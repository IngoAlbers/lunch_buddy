class Restaurant < ApplicationRecord
  has_many :daily_menus

  validates :name, presence: true

  def gather_daily_menu(date = Date.today)
    return unless content = set_content(date)

    daily_menus.create(date: date, content: content)
  end

  def self.gather_daily_menus(date = Date.today)
    all.each { |restaurant| restaurant.gather_daily_menu(date) }
  end

  private

  def set_content(date)
    lilly_jo(date) if name == 'Lilly Jo'
  end

  def lilly_jo(date)
    require 'open-uri'

    week = date.strftime('%W')
    io = open("https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-#{week}.pdf")
    reader = PDF::Reader.new(io)

    str = reader.objects.values.select { |v| v.class == Hash }.map { |v| v[:ActualText] }.join

    extract_menu(sanitize(str), date)&.strip
  end

  def extract_menu(str, date)
    date_start = I18n.l(date, format: '%A', locale: :de)
    date_end = I18n.l(date + 1.day, format: '%A', locale: :de)

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
end
