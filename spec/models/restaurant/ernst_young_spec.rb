# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant::ErnstYoung, type: :model do
  let(:ernst_young) { Restaurant::ErnstYoung.create! }

  it 'has the correct type' do
    expect(ernst_young.type).to eq('Restaurant::ErnstYoung')
  end

  describe '#get_contents' do
    it 'returns the correct menus for specified day' do
      date = Date.parse('14-08-2017')
      stub_request(:get, 'https://zfv.ch/de/microsites/ey-restaurant-platform/menuplan')
        .to_return(status: 200, body: file_fixture('ey_menuplan.html'))

      menus = ernst_young.get_contents(date)
      expect(menus.first).to include('Rindsfleischkugeln')
      expect(menus.second).to include('Röstipastetli')
    end
  end

  describe '#name' do
    it 'returns the correct name' do
      expect(ernst_young.name).to eq('Ernst & Young')
    end
  end
end
