# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

module Restaurant
  class ErnstYoung < BaseRestaurant
    def get_contents(date)
      doc = Nokogiri::HTML(open('https://zfv.ch/de/microsites/ey-restaurant-platform/menuplan'))

      menus = doc.css("table.menu tr[data-date='#{date.strftime('%F')}'] div.txt-hold")
      menus.css('.txt-slide').remove

      menus.map { |menu| menu.content.strip.split("\n\n").first.strip.tr("\n", ' ') }
    end
  end
end
