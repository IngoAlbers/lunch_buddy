# frozen_string_literal: true

module Restaurant
  class BaseRestaurant < ApplicationRecord
    self.table_name = 'restaurants'

    has_many :daily_menus, inverse_of: :restaurant, foreign_key: 'restaurant_id'

    validates :type, presence: true

    def self.gather_daily_menu(date = Date.today)
      return if self == BaseRestaurant
      restaurant = first_or_create

      restaurant.get_contents(date).each do |content|
        restaurant.daily_menus.create(date: date, content: content)
      end
    end

    def get_contents(_date)
      []
    end
  end
end
