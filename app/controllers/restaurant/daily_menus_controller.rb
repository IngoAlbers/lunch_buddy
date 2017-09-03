# frozen_string_literal: true

module Restaurant
  class DailyMenusController < ApplicationController
    before_action :set_daily_menu, only: :show

    def index
      render json: Restaurant::DailyMenu.of_today
    end

    def show
      render json: @daily_menu
    end

    private

    def set_daily_menu
      @daily_menu = Restaurant::DailyMenu.find(params[:id])
    end
  end
end
