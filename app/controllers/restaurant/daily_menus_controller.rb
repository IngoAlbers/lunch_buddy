# frozen_string_literal: true

module Restaurant
  class DailyMenusController < ApplicationController
    def index
      render json: Restaurant::DailyMenu.of_today
    end
  end
end
