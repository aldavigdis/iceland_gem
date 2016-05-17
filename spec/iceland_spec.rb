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
      postal_codes_with_boxes = Iceland.all_postal_codes(true)
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
  before(:context) do
    @kt_person1 = Kennitala.new('0101302989')
    @kt_company1 = Kennitala.new('4612023220')
  end
  it 'generates a valid random personal kennitala if no string is provided' do
    random_kt = Kennitala.new
    expect(random_kt.person?).to eq(true)
  end
  it 'enerates a valid random personal kennitala if kt_string equals false' do
    invalid_count = 0
    255.times do
      invalid_count += 1 unless Kennitala.new(false).person?
    end
    expect(invalid_count).to eq(0)
  end
  it 'generates a valid random company kennitala if is_company equals true' do
    invalid_count = 0
    255.times do
      invalid_count += 1 unless Kennitala.new(false, true).company?
    end
    expect(invalid_count).to eq(0)
  end
  it 'raises the correct argument error if the argument provided is not a '\
    'string or a boolean false' do
      expect { Kennitala.new(461_202_322_0) }
        .to raise_error(ArgumentError, 'Kennitala needs to be provided as a '\
                                       'String or Boolean (false)')
    end
  describe '.to_s' do
    it 'removes non-numeric characters from the kennitala string' do
      kt_with_junk = Kennitala.new('Mjá 🐈 kisa 010130-2989')
      expect(kt_with_junk.to_s).to eq('0101302989')
    end
  end
  describe '.to_date' do
    # This should cover .year, .month and .day as well
    it 'casts the kennitala to a Date object' do
      expect(@kt_person1.to_date).to be_an_instance_of(Date)
    end
  end

  describe '.age' do
    it 'calculates the age of a person in years and returns it as a Fixnum' do
      y_diff = Date.today.year - @kt_person1.year
      m_diff = Date.today.month - @kt_person1.month
      d_diff = Date.today.month - @kt_person1.month
      age = if m_diff < 0 || (m_diff == 0 && d_diff < 0)
              y_diff - 1
            else
              y_diff
            end
      expect(@kt_person1.age).to eq(age)
    end
    it 'calculates the age of a company in years and returns it as a Fixnum' do
      expect(@kt_company1.age).to be_an_instance_of(Fixnum)
    end
  end

  describe '.company?' do
    it 'figures out a company kennitala' do
      expect(@kt_company1.company?).to eq(true)
    end
    it 'figures out a personal kennitala' do
      expect(@kt_person1.company?).to eq(false)
    end
  end

  describe '.person?' do
    it 'figures out a company kennitala' do
      expect(@kt_company1.person?).to eq(false)
    end
    it 'figures out a personal kennitala' do
      expect(@kt_person1.person?).to eq(true)
    end  end

  describe '.entity_type' do
    it 'identifies a person' do
      expect(@kt_person1.entity_type).to eq('person')
    end
    it 'identifies a company' do
      expect(@kt_company1.entity_type).to eq('company')
    end
  end

  describe '.pp' do
    it 'uses a single space as the default spacer' do
      expect(@kt_person1.pp).to eq('010130 2989')
    end
    it 'adds a specific spacer if specified' do
      expect(@kt_person1.pp('-')).to eq('010130-2989')
    end
    it 'can handle emoji (or any multibyte utf-8 character) as a spacer' do
      # Why? - Just because!
      expect(@kt_person1.pp('🐈')).to eq('010130🐈2989')
    end
  end
end

describe String do
  it 'can be cast to kennitala using .to_kt' do
    expect('0101302989'.to_kt).to be_an_instance_of(Kennitala)
  end
  it 'will not be cast to a kennitala if invalid and will raise an error' do
    expect { ''.to_kt }.to raise_error(ArgumentError, 'Kennitala is invalid')
  end
end
