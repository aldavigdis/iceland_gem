# frozen_string_literal: true

require 'spec_helper'

describe Iceland do
  let(:postal_codes) { Iceland::PostalCode.list }

  describe '.all_postal_codes (depreciated)' do
    it 'functions the same as Iceland::PostalCode.list' do
      expect(all_postal_codes).to eq(Iceland::PostalCode.list)
      expect(all_postal_codes(true)).to eq(Iceland::PostalCode.list(true))
      expect(all_postal_codes(true, true))
        .to eq(Iceland::PostalCode.list(true, true))
    end
  end
  describe '.locale_by_postal_code (depricated)' do
    it 'functions the same as Iceland::PostalCode.find_locale' do
      postal_codes.each do |p|
        expect(locale_by_postal_code(p[:postal_code])).not_to be_nil
        expect(locale_by_postal_code(p[:postal_code]))
          .to eq(Iceland::PostalCode.find_locale(p[:postal_code]))
        expect(locale_by_postal_code(p[:postal_code], true))
          .to eq(Iceland::PostalCode.find_locale(p[:postal_code], true))
      end
    end
  end
end
