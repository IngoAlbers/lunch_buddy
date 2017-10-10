# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant::LillyJo, type: :model do
  let(:lilly_jo) { create(:lilly_jo) }

  it 'has the correct type' do
    expect(lilly_jo.type).to eq('Restaurant::LillyJo')
  end

  describe '#get_contents' do
    it 'returns the correct menus for specified day' do
      date = Date.parse('02-08-2017')
      stub_request(:get, 'https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-31.pdf')
        .to_return(status: 200, body: file_fixture('lilly-jo_wochenmenue_kw-31.pdf'))
      expect(lilly_jo.get_contents(date)).to eq [menu1, menu2]
    end

    context 'when the default menu is not of current year' do
      it 'returns menus from the fallback url' do
        date = Date.parse('03-10-2017')
        stub_request(:get, 'https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-40.pdf')
        .to_return(status: 200, body: file_fixture('lilly-jo_wochenmenue_kw-40.pdf'))
        stub_request(:get, 'https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-40-1.pdf')
        .to_return(status: 200, body: file_fixture('lilly-jo_wochenmenue_kw-40-1.pdf'))

        expect(lilly_jo.get_contents(date)).to eq [menu3, menu4]
      end
    end
  end

  describe '#name' do
    it 'returns the correct name' do
      expect(lilly_jo.name).to eq('Lilly Jo')
    end
  end

  private

  def menu1
    [
      'Köstliche Sprossen mit',
      '*indisches Gemüsecurry mit gerösteten Cashewkernen und Naan Brot*',
      'und so viel Brot wie man mag'
    ].join(' ')
  end

  def menu2
    [
      'Köstliche Sprossen',
      '*auf Parmaschinken gebratene Maispoulardenbrust Kräuterjus Kartoffelstock buntes Mischgemüse*',
      'und so viel Brot wie man mag'
    ].join(' ')
  end

  def menu3
    [
      'Köstliche Sprossen mit',
      '*Indisches Linsen Dal Naan Brot*',
      'und so viel Brot wie man mag'
    ].join(' ')
  end

  def menu4
    [
      'Köstliche Sprossen mit',
      '*zartes Rinderragout an Burgundersauce Pappardelle und Rotkraut*',
      'und so viel Brot wie man mag'
    ].join(' ')
  end
end
