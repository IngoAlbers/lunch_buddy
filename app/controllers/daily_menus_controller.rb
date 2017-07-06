class DailyMenusController < ActionController::Base
  def index
    render json: DailyMenu.of_today
  rescue StandardError
    render json: { l(date) => 'error' }
  end
end
