class DailyMenu < ApplicationRecord
  belongs_to :restaurant

  scope :of_today, -> { where(date: Date.today.beginning_of_day) }

  validates :date, :content, presence: true

  def broadcast
    message = "*Heute (#{date.strftime('%F')}) im #{restaurant.name}:*\n"
    message << content

    @client ||= SlackClient.new
    @client.chat_postMessage(channel: '#lunchtime', text: message, as_user: true)
  end

  def self.broadcast
    of_today.each(&:broadcast)
  end
end
