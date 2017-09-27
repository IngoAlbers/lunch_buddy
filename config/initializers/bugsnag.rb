# frozen_string_literal:true

Bugsnag.configure do |config|
  config.api_key = ENV['LUNCHBUDDY_BUGSNAG_API_TOKEN']
end
