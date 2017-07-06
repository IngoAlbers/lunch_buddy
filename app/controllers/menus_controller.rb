class MenusController < ActionController::Base
  def show
    render json: DailyMenu.of_today
  rescue StandardError
    render json: { l(date) => 'error' }
  end
end
