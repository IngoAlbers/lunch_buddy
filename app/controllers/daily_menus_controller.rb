class DailyMenusController < ActionController::Base
  def index
    render json: DailyMenu.of_today
  end
end