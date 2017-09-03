# frozen_string_literal: true

FactoryGirl.define do
  factory :lilly_jo, class: Restaurant::LillyJo
  factory :ernst_young, class: Restaurant::ErnstYoung
  factory :naanu, class: Restaurant::Naanu

  factory :daily_menu, class: Restaurant::DailyMenu do
    restaurant { Restaurant::LillyJo.first || create(:lilly_jo) }
    date Date.today
    content 'Schnitzel'

    trait :of_yesterday do
      date Date.yesterday
    end
  end
end
