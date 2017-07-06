class MenusController < ActionController::Base
  def show
    render json: DailyMenu.where(date: Date.today.beginning_of_day)
  rescue StandardError
    render json: { l(date) => 'error' }
  end
end
