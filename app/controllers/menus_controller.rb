class MenusController < ActionController::Base
  def lilly_jo
    date = if params[:date]
            Date.parse(params[:date])
          else
            Date.today
          end

    daily_menu = DailyMenu.create(restaurant: 'lilly_jo', date: date)

    render json: { l(date) => daily_menu.content }
  rescue StandardError
    render json: { l(date) => 'error' }
  end
end
