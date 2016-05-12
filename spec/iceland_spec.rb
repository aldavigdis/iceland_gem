require 'spec_helper'

describe Iceland do
  it 'has a version number' do
    expect(Iceland::VERSION).not_to be nil
  end

  describe '.all_postal_codes method' do
    it 'returns an array of hashes, including each postal code' do
      postal_codes = Iceland.all_postal_codes
      maxindex = postal_codes.length - 1
      random_index = Random.rand(0..maxindex)
      expect(postal_codes[random_index][:postal_code]).to be_a Fixnum
    end

    it 'returns an array of hashes, including each locale' do
      postal_codes = Iceland.all_postal_codes
      maxindex = postal_codes.length - 1
      random_index = Random.rand(0..maxindex)
      expect(postal_codes[random_index][:locale]).to be_a String
    end

    it 'returns P.O. box postal codes when include_po_boxes is true' do
      postal_codes_without_boxes = Iceland.all_postal_codes
      postal_codes_with_boxes = Iceland.all_postal_codes true
      expect(postal_codes_without_boxes.length < postal_codes_with_boxes.length)
        .to eq(true)
    end

    it 'returns the nomative form of locale when force_nominative is true' do
      postal_codes_dative = Iceland.all_postal_codes
      postal_codes_nomative = Iceland.all_postal_codes false, true
      expect(postal_codes_dative == postal_codes_nomative).to eq(false)
    end
  end

  describe '.locale_by_postal_code method' do
    it 'returns nil if the postal code is not found or invalid' do
      expect(locale_by_postal_code(9999)).to be_nil
    end
    it 'returns the dative form of a locale name by default' do
      expect(locale_by_postal_code(310)).to eq('Borgarnesi')
    end
    it 'returns the nomative form of a locale if force_nominative is true' do
      expect(locale_by_postal_code(310, true)).to eq('Borgarnes')
    end
    it 'accepts strings as postal_code' do
      expect(locale_by_postal_code('900')).to eq('Vestmannaeyjum')
    end
  end
end

describe Kennitala do
end
