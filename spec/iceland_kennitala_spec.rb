# frozen_string_literal: true

require 'spec_helper'

describe Iceland::Kennitala do
  let(:kt_person) { Iceland::Kennitala.new('0101302989') }
  let(:kt_company) { Iceland::Kennitala.new('4612023220') }

  it 'generates a valid random personal kennitala if no string is provided' do
    invalid_count = 0
    255.times do
      invalid_count += 1 unless Iceland::Kennitala.new
    end
    expect(invalid_count).to eq(0)
  end

  it 'generates a valid random personal kennitala if kennitala is provided '\
     'as boolean false' do
       invalid_count = 0
       255.times do
         invalid_count += 1 unless Iceland::Kennitala.new(false)
       end
       expect(invalid_count).to eq(0)
     end

  it 'enerates a valid random personal kennitala if kt_string equals false' do
    invalid_count = 0
    255.times do
      invalid_count += 1 unless Iceland::Kennitala.new(false).person?
    end
    expect(invalid_count).to eq(0)
  end

  it 'generates a valid random company kennitala if is_company equals true' do
    invalid_count = 0
    255.times do
      invalid_count += 1 unless Iceland::Kennitala.new(false, true).company?
    end
    expect(invalid_count).to eq(0)
  end

  it 'raises the correct argument error if the argument provided is not a '\
    'string or a boolean false' do
      expect { Iceland::Kennitala.new(461_202_322_0) }
        .to raise_error(ArgumentError, 'Kennitala needs to be provided as a '\
                                       'String or Boolean (false)')
    end

  describe '.to_s' do
    it 'removes non-numeric characters from the kennitala string' do
      kt_with_junk = Iceland::Kennitala.new('Mjá 🐈 kisa 010130-2989')
      expect(kt_with_junk.to_s).to eq('0101302989')
    end
  end

  describe '.to_date' do
    # This should cover .year, .month and .day as well
    it 'casts the kennitala to a Date object' do
      expect(kt_person.to_date).to be_an_instance_of(Date)
    end
  end

  describe '.age' do
    it 'calculates the age of a person in years and returns it as a Integer' do
      y_diff = Date.today.year - kt_person.year
      m_diff = Date.today.month - kt_person.month
      d_diff = Date.today.month - kt_person.month
      age = if m_diff < 0 || (m_diff == 0 && d_diff < 0)
              y_diff - 1
            else
              y_diff
            end
      expect(kt_person.age).to eq(age)
    end
    it 'calculates the age of a company in years and returns it as a Integer' do
      expect(kt_company.age).to be_an_instance_of(Integer)
    end
  end

  describe '.company?' do
    it 'figures out a company kennitala' do
      expect(kt_company.company?).to eq(true)
    end
    it 'figures out a personal kennitala' do
      expect(kt_person.company?).to eq(false)
    end
  end

  describe '.person?' do
    it 'figures out a company kennitala' do
      expect(kt_company.person?).to eq(false)
    end
    it 'figures out a personal kennitala' do
      expect(kt_person.person?).to eq(true)
    end  end

  describe '.entity_type' do
    it 'identifies a person' do
      expect(kt_person.entity_type).to eq('person')
    end
    it 'identifies a company' do
      expect(kt_company.entity_type).to eq('company')
    end
  end

  describe '.pp' do
    it 'uses a single space as the default spacer' do
      expect(kt_person.pp).to eq('010130 2989')
    end
    it 'adds a specific spacer if specified' do
      expect(kt_person.pp('-')).to eq('010130-2989')
    end
    it 'can handle emoji (or any multibyte utf-8 character) as a spacer' do
      # Why? - Just because!
      expect(kt_person.pp('🐈')).to eq('010130🐈2989')
    end
  end
end

describe String do
  it 'can be cast to kennitala using .to_kt' do
    expect('0101302989'.to_kt).to be_an_instance_of(Iceland::Kennitala)
  end
  it 'will not be cast to a kennitala if invalid and will raise an error' do
    expect { ''.to_kt }.to raise_error(ArgumentError, 'Kennitala is invalid')
  end
end
