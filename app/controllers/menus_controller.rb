class MenusController < ActionController::Base
  def show
    date = if params[:date]
            Date.parse(params[:date])
          else
            Date.today
          end

    daily_menu = DailyMenu.find_by(date: date.beginning_of_day)

    render json: { l(date) => daily_menu.content }
  rescue StandardError
    render json: { l(date) => 'error' }
  end
end
