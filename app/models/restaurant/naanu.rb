# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

module Restaurant
  class Naanu < BaseRestaurant
    def get_contents(_date)
      doc = Nokogiri::HTML(open('http://www.naanu.ch/index.php?id=93'))

      menus = doc.css('.meu-box-2-print')

      menus.map { |menu| menu.inner_html.gsub(/<b>|[*]/, '').split('</b>').map(&:strip) }
           .map { |menu| "*#{menu.first}* #{menu.last}" }
    end
  end
end
