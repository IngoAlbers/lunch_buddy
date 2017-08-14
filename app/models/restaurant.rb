# frozen_string_literal: true

module Restaurant
  def self.gather_daily_menus(date = Date.today)
    Restaurant.require_subclasses
    Restaurant::BaseRestaurant.subclasses.each { |restaurant| restaurant.gather_daily_menu(date) }
  end

  # Needed because rake tasks don't eager load the models even in production
  def self.require_subclasses
    Dir[File.expand_path('restaurant/*.rb', __dir__)].each { |src| require src }
  end
end
