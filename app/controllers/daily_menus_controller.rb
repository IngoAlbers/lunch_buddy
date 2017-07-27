# frozen_string_literal: true

class DailyMenusController < ApplicationController
  def index
    render json: DailyMenu.of_today
  end
end
