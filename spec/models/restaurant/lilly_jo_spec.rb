# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant::LillyJo, type: :model do
  let(:lilly_jo) { Restaurant::LillyJo.create! }

  it 'has the correct type' do
    expect(lilly_jo.type).to eq('Restaurant::LillyJo')
  end

  describe '#get_contents' do
    it 'returns the correct menus for specified day' do
      date = Date.parse('19-7-2017')
      menus = ['Köstliche Sprossen mit Tofu-Gulasch mit Erbsenpolenta', 'Köstliche Sprossen mit Hackbraten an Kräuter-Rahmsauce Kartoffelstock und junge Erbsen']

      stub_request(:get, 'https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-29.pdf')
        .to_return(status: 200, body: file_fixture('lilly-jo_wochenmenue_kw-29.pdf'))

      expect(lilly_jo.get_contents(date)).to eq menus
    end
  end
end
