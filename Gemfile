# frozen_string_literal: true

ruby '2.4.2'

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.1'
# Use postgres as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.3'

gem 'execjs'
gem 'turbolinks'
gem 'uglifier'
gem 'webpacker'

# Localization
gem 'i18n'

# PDF parsing
gem 'pdf-reader'

# HTML/XML parsing
gem 'nokogiri'

# Slack Bot
gem 'slack-ruby-client'

# Scheduler
gem 'whenever', require: false

# Report unhandled errors
gem 'bugsnag'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Use rspec for testing
  gem 'rspec-rails'
  gem 'webmock'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'factory_girl_rails'
  gem 'faker'
end
