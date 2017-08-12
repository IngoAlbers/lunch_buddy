# frozen_string_literal: true

require 'open-uri'

module Restaurant
  class ErnstYoung < BaseRestaurant
    def get_contents(_date)
      url = 'https://zfv.ch/de/microsites/ey-restaurant-platform/menuplan'

      url
    end
  end
end
