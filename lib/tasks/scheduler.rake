# frozen_string_literal:true

desc 'This task is called by the Heroku scheduler add-on'

namespace :daily_menus do
  task gather: :environment do
    Restaurant.gather_daily_menus
  end

  task broadcast: :environment do
    Restaurant::DailyMenu.broadcast
  end
end
