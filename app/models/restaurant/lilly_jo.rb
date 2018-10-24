# frozen_string_literal: true

require 'open-uri'

module Restaurant
  class LillyJo < BaseRestaurant
    def get_contents(date)
      current_day = I18n.l(date, format: '%A', locale: :de)
      extract_menu(menu_url(date), current_day)
    end

    def name
      'Lilly Jo'
    end

    private

    def extract_menu(url, current_day)
      menu_fragments(url, current_day).map(&method(:funnify))
    end

    def all_fragments(url)
      @all_fragments ||= PDF::Reader.new(URI.parse(url).open)
                                    .objects
                                    .values
                                    .select { |v| v.class == Hash }
                                    .map { |v| v[:ActualText] }
    end

    def current_day_fragments(url, current_day)
      all_fragments(url).inject([[]], &method(:split_on_weekday_reducer))
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

    def split_on_weekday_reducer(acc, target)
      *days, day = acc
      weekdays = %w[Montag Dienstag Mittwoch Donnerstag Freitag]
      weekdays.include?(target) ? [*acc, [target]] : [*days, [*day, target]]
    end

    def split_on_consecutive_nil_reducer(acc, target)
      *segments, last_segment = acc
      last_segment.last.nil? && target.nil? ? [*acc, [target]] : [*segments, [*last_segment, target]]
    end

    def sanitize(str)
      str = str.force_encoding('ASCII-8BIT')
               .gsub(regexify('\x00|\xFE|\xFF|\xA8'), '')
               .gsub(regexify('\xE4'), 'aaee')
               .gsub(regexify('\xF6'), 'ooee')
               .gsub(regexify('\xFC'), 'uuee')
               .gsub(regexify('\xE9|\xE8'), 'e')
               .gsub(regexify('\xE0'), 'a')
               .gsub(regexify('\xFB'), 'u')
               .gsub(regexify('\xF4'), 'o')

      umlautify(str)
    end

    def umlautify(str)
      str = str.force_encoding('ASCII-8BIT')
               .gsub(regexify('\xC4'), 'AAEE')
               .gsub(regexify('\xD6'), 'OOEE')
               .gsub(regexify('\xDC'), 'UUEE')

      # Workaround to make sure that 'ue' in 'sauer' doesn't turn to the umlaut
      str.gsub('aaee', 'ä')
         .gsub('AAEE', 'Ä')
         .gsub('ooee', 'ö')
         .gsub('OOEE', 'Ö')
         .gsub('uuee', 'ü')
         .gsub('UUEE', 'Ü')
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

    def regexify(str)
      str = +str
      Regexp.new(str.force_encoding('ASCII-8BIT'))
    end

    def ensure_current_year(url)
      return true if all_fragments(url)&.include?(Date.current.year.to_s)

      @all_fragments = nil
      false
    end

    def menu_url(date)
      week = date.strftime('%W')
      month = date.strftime('%m')
      year = date.strftime('%Y')

      url = "https://lillyjo.ch/wp-content/uploads/#{year}/#{month}/lilly-jo_wochenmenue_kw-#{week}.pdf"

      ensure_current_year(url) ? url : fallback_url(url)
    end

    def fallback_url(url)
      "#{url.split('.pdf').first}-1.pdf"
    end
  end
end
