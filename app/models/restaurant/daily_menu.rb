module Restaurant
  class DailyMenu < ApplicationRecord
    belongs_to :restaurant, class_name: 'BaseRestaurant', foreign_key: 'restaurant_id', inverse_of: :daily_menus

    scope :of_today, -> { where(date: Date.today.beginning_of_day) }

    validates :date, :content, presence: true

    def broadcast
      message = "*Heute (#{date.strftime('%F')}) im #{restaurant.class.name.demodulize}:*\n"
      message << content

      slack_client.post_message(message)
    end

    def self.broadcast
      of_today.each(&:broadcast)
    end

    private

    def slack_client
      @client ||= SlackClient.new
    end
  end
end
