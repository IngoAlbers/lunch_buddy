# frozen_string_literal:true

desc 'This tasks are called by the Heroku scheduler add-on'

namespace :daily_menus do
  task gather: :environment do
    next if Date.today.on_weekend?

    Restaurant.gather_daily_menus
  end

  task broadcast: :environment do
    next if Date.today.on_weekend?

    Restaurant::DailyMenu.broadcast
  end
end
