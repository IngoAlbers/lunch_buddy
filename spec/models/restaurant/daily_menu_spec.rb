# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant::DailyMenu, type: :model do
  let(:lilly_jo) { Restaurant::LillyJo.create! }
  let(:menu_today) { Restaurant::DailyMenu.create(restaurant: lilly_jo, date: Date.today, content: 'Schnitzel') }
  let(:menu_yesterday) { Restaurant::DailyMenu.create(restaurant: lilly_jo, date: Date.yesterday, content: 'Fisch') }

  describe '.of_today' do
    it 'includes daily menu of today' do
      expect(Restaurant::DailyMenu.of_today).to include(menu_today)
    end

    it 'does not include daily menu of yesterday' do
      expect(Restaurant::DailyMenu.of_today).not_to include(menu_yesterday)
    end
  end
end
