# frozen_string_literal:true

desc 'This task is called by the Heroku scheduler add-on'

namespace :daily_menus do
  task gather: :environment do
    abort("Leave me alone. It's the weekend!") if Date.today.on_weekend?
    Restaurant.gather_daily_menus
  end

  task broadcast: :environment do
    abort('No broadcasts on the weekend!') if Date.today.on_weekend?
    Restaurant::DailyMenu.broadcast
  end
end
