module Restaurant
  class LillyJo < BaseRestaurant
    def set_content(date)
      require 'open-uri'

      week = date.strftime('%W')
      io = open("https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-#{week}.pdf")
      reader = PDF::Reader.new(io)

      str = reader.objects.values.select { |v| v.class == Hash }.map { |v| v[:ActualText] }.join

      extract_menu(sanitize(str), date)&.strip
    end

    private

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
end
