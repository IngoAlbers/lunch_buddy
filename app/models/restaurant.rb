module Restaurant
  def self.gather_daily_menus(date = Date.today)
    Restaurant::BaseRestaurant.subclasses.each { |restaurant| restaurant.gather_daily_menu(date) }
  end
end
