require 'open-uri'

module Restaurant
  class LillyJo < BaseRestaurant

    def get_contents(date)
      week = date.strftime('%W')
      current_day = I18n.l(date, format: '%A', locale: :de)
      url = "https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-#{week}.pdf"

      extract_menu(url, current_day)
    end

    private

    def extract_menu(url, current_day)
      PDF::Reader.new(open(url))
        .objects
        .values
        .select { |v| v.class == Hash }
        .map { |v| v[:ActualText] }
        .inject([[]], &method(:split_on_weekday_reducer))
        .group_by(&:first)[current_day]
        .first
        .drop(1)
        .inject([[]], &method(:split_on_consecutive_nil_reducer))
        .map(&:join)
        .map(&method(:sanitize))
        .map(&:squish)
        .reject { |x| x == "" }
    end

    def split_on_weekday_reducer(acc, t)
      *days, day = acc
      weekdays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag"]
      weekdays.include?(t) ? [*acc, [t]] : [*days, [*day, t]]
    end

    def split_on_consecutive_nil_reducer(acc, t)
      *segments, last_segment = acc
      last_segment.last.nil? && t.nil? ? [*acc, [t]] : [*segments, [*last_segment, t]]
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
