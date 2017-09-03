# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant::DailyMenu, type: :model do
  let(:menu_today) { create(:daily_menu) }
  let(:menu_yesterday) { create(:daily_menu, :of_yesterday) }

  describe '.of_today' do
    it 'includes daily menu of today' do
      expect(Restaurant::DailyMenu.of_today).to include(menu_today)
    end

    it 'does not include daily menu of yesterday' do
      expect(Restaurant::DailyMenu.of_today).not_to include(menu_yesterday)
    end
  end
end
