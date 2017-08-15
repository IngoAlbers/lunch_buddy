# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant::Naanu, type: :model do
  let(:naanu) { Restaurant::Naanu.create! }

  it 'has the correct type' do
    expect(naanu.type).to eq('Restaurant::Naanu')
  end

  describe '#get_contents' do
    it 'returns the correct menus for specified day' do
      stub_request(:get, 'http://www.naanu.ch/index.php?id=93')
        .to_return(status: 200, body: file_fixture('naanu_menuplan.html'))

      menus = naanu.get_contents(Date.today)
      expect(menus.first).to eq '*«Naan»* Im Tonofen gebackenes Fladenbrot'
      expect(menus.second).to eq '*Butter Chicken* Poulet an einer feinen Tomaten-Rahm-Sauce ' \
                                 'mit Honig und Ingwer verfeinert'
    end
  end

  describe '#name' do
    it 'returns the correct name' do
      expect(naanu.name).to eq('Naanu')
    end
  end
end
