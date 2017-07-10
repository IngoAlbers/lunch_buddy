module Restaurant
  class BaseRestaurant < ApplicationRecord
    self.table_name = 'restaurants'

    has_many :daily_menus, inverse_of: :restaurant, foreign_key: 'restaurant_id'

    validates :type, presence: true

    def self.gather_daily_menu(date = Date.today)
      return if self == BaseRestaurant
      restaurant = first_or_create
      content = restaurant.set_content(date)

      restaurant.daily_menus.create(date: date, content: content) if content.present?
    end

    def set_content(date); end
  end
end
