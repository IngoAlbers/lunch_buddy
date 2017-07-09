module Restaurant
  class BaseRestaurant < ApplicationRecord
    self.table_name = 'restaurants'

    has_many :daily_menus, inverse_of: :restaurant, foreign_key: 'restaurant_id'

    validates :type, presence: true

    def self.gather_daily_menu(date = Date.today)
      return unless restaurant = first
      return unless content = restaurant.set_content(date)

      restaurant.daily_menus.create(date: date, content: content)
    end

    def set_content(date); end
  end
end
