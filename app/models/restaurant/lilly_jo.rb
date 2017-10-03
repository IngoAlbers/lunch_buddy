# frozen_string_literal: true

require 'open-uri'

module Restaurant
  class LillyJo < BaseRestaurant
    def get_contents(date)
      week = date.strftime('%W')
      current_day = I18n.l(date, format: '%A', locale: :de)
      url = "https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-#{week}.pdf"

      return [] unless ensure_current_year(url)

      extract_menu(url, current_day)
    end

    def name
      'Lilly Jo'
    end

    private

    def extract_menu(url, current_day)
      menu_fragments(url, current_day).map(&method(:funnify))
    end

    def current_day_fragments(url, current_day)
      pdf_reader(url).inject([[]], &method(:split_on_weekday_reducer))
                     .group_by(&:first)[current_day]
                     .first
                     .drop(1)
    end

    def menu_fragments(url, current_day)
      current_day_fragments(url, current_day).inject([[]], &method(:split_on_consecutive_nil_reducer))
                                             .map(&:join)
                                             .map(&method(:sanitize))
                                             .reject { |x| x == '' }
    end

    def split_on_weekday_reducer(acc, t)
      *days, day = acc
      weekdays = %w[Montag Dienstag Mittwoch Donnerstag Freitag]
      weekdays.include?(t) ? [*acc, [t]] : [*days, [*day, t]]
    end

    def split_on_consecutive_nil_reducer(acc, t)
      *segments, last_segment = acc
      last_segment.last.nil? && t.nil? ? [*acc, [t]] : [*segments, [*last_segment, t]]
    end

    def sanitize(str)
      str = str.dup.force_encoding('ASCII-8BIT')
               .gsub(/#{"\x00|\xFE|\xFF|\xA8".dup.force_encoding("ASCII-8BIT")}/, '')
               .gsub(/#{"\xE4".dup.force_encoding("ASCII-8BIT")}/, 'aaee')
               .gsub(/#{"\xF6".dup.force_encoding("ASCII-8BIT")}/, 'ooee')
               .gsub(/#{"\xFC".dup.force_encoding("ASCII-8BIT")}/, 'uuee')
               .gsub(/#{"\xE9|\xE8".dup.force_encoding("ASCII-8BIT")}/, 'e')
               .gsub(/#{"\xE0".dup.force_encoding("ASCII-8BIT")}/, 'a')
               .gsub(/#{"\xFB".dup.force_encoding("ASCII-8BIT")}/, 'u')

      # Workaround to make sure that 'ue' in 'sauer' doesn't turn to the umlaut
      str.gsub('aaee', 'ä')
         .gsub('ooee', 'ö')
         .gsub('uuee', 'ü')
         .squish
    end

    def funnify(str)
      boldified = boldify(str)
      sprossified = sprossify(boldified)
      brotify(sprossified)
    end

    def sprossify(str)
      [
        'Köstliche Sprossen',
        str.downcase.start_with?('*auf ') ? nil : 'mit',
        str
      ].compact.join(' ')
    end

    def brotify(str)
      "#{str} und so viel Brot wie man mag"
    end

    def boldify(str)
      "*#{str}*"
    end

    def ensure_current_year(url)
      pdf_reader(url).include?(Date.current.year.to_s)
    end

    def pdf_reader(url)
      @pdf_reader ||= PDF::Reader.new(open(url))
                                 .objects
                                 .values
                                 .select { |v| v.class == Hash }
                                 .map { |v| v[:ActualText] }
    end
  end
end
