class DailyMenu < ApplicationRecord
  belongs_to :restaurant

  scope :of_today, -> { where(date: Date.today.beginning_of_day) }

  validates :date, :content, presence: true

  def broadcast
    message = "*Heute (#{date.strftime('%F')}) im #{restaurant.name}:*\n"
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
