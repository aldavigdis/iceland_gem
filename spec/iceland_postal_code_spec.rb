# frozen_string_literal: true

require 'spec_helper'

describe Iceland::PostalCode do
  let(:postal_codes) { Iceland::PostalCode.list }
  let(:postal_codes_with_boxes) do
    Iceland::PostalCode.list(include_po_boxes: true)
  end
  let(:postal_codes_with_nomative_locales) do
    Iceland::PostalCode.list(nomative: true)
  end

  describe '.list' do
    it 'returns an array of hashes, including each postal code' do
      postal_codes.each do |p|
        expect(p[:postal_code]).to be_a Integer
        expect(p[:locale]).to be_a String
      end
    end
    it 'returns PO Box postcodes when required' do
      expect(postal_codes.length < postal_codes_with_boxes.length).to eq(true)
    end
    it 'returns a nomative locale name when required' do
      different_format_count = 0
      postal_codes.each_with_index do |p, i|
        if p[:locale] != postal_codes_with_nomative_locales[i][:locale]
          different_format_count += 1
        end
      end
      expect(different_format_count).not_to eq(0)
      expect(different_format_count).not_to eq(postal_codes.length)
    end
  end

  describe '.find_locale' do
    it 'returns if the postal code is not found or invalid' do
      expect(Iceland::PostalCode.find_locale(9999)).to be_nil
    end
    it 'returns the dative form of a locale name by default' do
      expect(Iceland::PostalCode.find_locale(310)).to eq('Borgarnesi')
    end
    it 'returns the nomative form of a locale if force_nominative is true' do
      expect(Iceland::PostalCode.find_locale(310, true)).to eq('Borgarnes')
    end
    it 'accepts strings as postal_code' do
      expect(Iceland::PostalCode.find_locale('900')).to eq('Vestmannaeyjum')
    end
  end
end
