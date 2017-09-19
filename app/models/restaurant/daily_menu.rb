# frozen_string_literal: true

module Restaurant
  class DailyMenu < ApplicationRecord
    belongs_to :restaurant, class_name: 'BaseRestaurant', foreign_key: 'restaurant_id', inverse_of: :daily_menus

    scope :of_today, -> { where(date: Date.today.beginning_of_day) }

    validates :date, :content, presence: true

    def self.broadcast
      of_today.order(:restaurant_id).group_by(&:restaurant).each_pair do |restaurant, daily_menus|
        message = String.new("*Heute (#{Date.today.strftime('%F')}) im #{restaurant.name}:*\n")

        daily_menus.each do |daily_menu|
          message << "• #{daily_menu.content}\n"
        end
        message << ':blank:'

        slack_client.post_message(message)
      end
    end

    def self.slack_client
      @client ||= SlackClient.new
    end
  end
end
