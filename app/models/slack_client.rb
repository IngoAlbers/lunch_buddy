# frozen_string_literal: true

require 'slack-ruby-client'
class SlackClient < Slack::Web::Client
  def post_message(message)
    chat_postMessage(channel: chat_channel, text: message, as_user: true)
  end

  private

  def chat_channel
    Rails.env.production? ? '#lunchbuddy' : '#lunchtimetest'
  end
end
