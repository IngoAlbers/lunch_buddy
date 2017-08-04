# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant::LillyJo, type: :model do
  let(:lilly_jo) { Restaurant::LillyJo.create! }

  it 'has the correct type' do
    expect(lilly_jo.type).to eq('Restaurant::LillyJo')
  end

  describe '#get_contents' do
    it 'returns the correct menus for specified day' do
      date = Date.parse('02-08-2017')
      menus = [
        'Köstliche Sprossen mit indisches Gemüsecurry mit gerösteten Cashewkernen und Naan Brot und so viel Brot wie man mag',
        'Köstliche Sprossen auf Parmaschinken gebratene Maispoulardenbrust Kräuterjus Kartoffelstock buntes Mischgemüse und so viel Brot wie man mag'
      ]

      stub_request(:get, 'https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-31.pdf')
        .to_return(status: 200, body: file_fixture('lilly-jo_wochenmenue_kw-31.pdf'))

      expect(lilly_jo.get_contents(date)).to eq menus
    end
  end
end
