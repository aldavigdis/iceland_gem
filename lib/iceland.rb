require 'date'
require 'yaml'

require 'iceland/version'

# The Iceland Module
module Iceland
  POSTAL_CODES = YAML.load_file(File.expand_path('../postcodes.yml', __FILE__))

  # Get an array of hashes with postal_code and locale attributes
  #
  # @param [Boolean] include_po_boxes Include postal codes for P.O. boxes
  # @param [Boolean] force_nominative Use the nomative version of locale name
  # @return [Array]
  def all_postal_codes(include_po_boxes = false, force_nominative = false)
    pairs = []
    POSTAL_CODES.each do |postal_code, p|
      # Skip P.O. boxes
      next if (include_po_boxes == false) && (p['is_po_box'] == true)
      # Retun the dative form of the locale by default
      pairs << if p['dative'].nil? || force_nominative == true
                 { postal_code: postal_code, locale: p['locale'] }
               else
                 { postal_code: postal_code, locale: p['dative'] }
               end
    end
    pairs
  end

  # Find the name of locale (city/town/village) by postal code
  #
  # @param [Integer, String] postal_code The postal code
  # @param [Boolean] force_nominative Display locale name in nomative form
  # @return [String] description of returned object
  def locale_by_postal_code(postal_code, force_nominative = false)
    postal_code = postal_code.to_i
    postal_code_hash = POSTAL_CODES[postal_code]
    unless postal_code_hash.nil?
      if postal_code_hash['dative'].nil? || force_nominative == true
        return postal_code_hash['locale']
      end
      postal_code_hash['dative']
    end
  end
end

# The Kennitala Class
class Kennitala
  def initialize(kt_string)
    unless kt_string.class == String
      raise ArgumentError, 'Kennitala needs to be provided as a string'
    end
    sanitised_kt = sanitize(kt_string)
    raise ArgumentError, 'Kennitala is invalid' if sanitised_kt.nil?
    @value = sanitised_kt
  end

  # Get the type of entity - If it is a person or an organization
  #
  # @return [String] Either 'person' or 'company'
  def entity_type
    date_integer = @value[0, 2].to_i
    return 'person' if date_integer < 32
    return 'company' if (date_integer > 40) && (date_integer < 71)
    false
  end

  # Check if the entity is a company
  #
  # @return [Boolean]
  def company?
    date_integer = @value[0, 2].to_i
    return true if (date_integer > 40) && (date_integer < 71)
    false
  end

  # Check if the entity is a person
  #
  # @return [Type] description of returned object
  def person?
    date_integer = @value[0, 2].to_i
    return true if date_integer < 32
    false
  end

  # Get the year of birth or registration
  #
  # @return [Fixnum]
  def year
    century = (10 + @value[9].to_i) * 100
    year = @value[4, 2].to_i
    return century + year if (1800..1900).cover?(century)
    return 2000 + year if century == 1000
  end

  # Get the day of the month of birth or registration
  #
  # @return [Fixnum]
  def day
    date_integer = @value[0, 2].to_i
    return @value[0, 2].to_i if date_integer < 32
    return @value[0, 2].to_i - 40 if (date_integer > 40) && (date_integer < 71)
  end

  # Get a numeric representation of the month of birth or registration
  #
  # @return [Fixnum]
  def month
    @value[2, 2].to_i
  end

  # Get the age of entity in years. Useful when dealing with age restrictions.
  #
  # @return [Fixnum]
  def age
    year_diff = Date.today.year - to_date.year
    month_diff = Date.today.month - to_date.month
    day_diff = Date.today.month - to_date.month

    return year_diff -= 1 if month_diff < 0 || (month_diff == 0 && day_diff < 0)
    year_diff
  end

  # Cast the kennitala to a Date object
  #
  # @return [Date]
  def to_date
    Date.new(year, month, day)
  end

  # Cast the kennitala to a String object
  #
  # @return [Date]
  def to_s
    @value.to_s
  end

  private

  # Sanitize the kennitala
  #
  # @param [String] kt_string Unsanitised string representing a kennitala
  # @return [String] Sanitized kennitala
  def sanitize(kt_string)
    sanitized_kt = kt_string.gsub(/\D/, '')
    checks = check_checksum(sanitized_kt)
    return sanitized_kt if (/\A\d{10}\z/ =~ sanitized_kt) && (checks == true)
  end

  # Calculate the checksum
  #
  # @param [String] kt_string Sanitized kennitala
  # @return [Fixnum] The checksum
  def checksum(kt_string)
    checksum = 0
    multipliers = [3, 2, 7, 6, 5, 4, 3, 2]
    multipliers.each_with_index do |multiplier, index|
      checksum += multiplier * kt_string[index].to_i
    end
    checksum
  end

  # Calculate remainder and check validity of the check digit
  #
  # @param [String] kt_string Sanitized kennitala
  # @return [Boolean, nil] true on success, nil if the check digit is invalid
  def check_checksum(kt_string)
    remainder = checksum(kt_string).modulo(11)

    # A kennitala with a remainder of 10 is always considered to be invalid
    return nil if remainder == 10

    # The check digit should be 11 minus the remainder,
    # unless the remainder is 0, then the theck digit becomes 0.
    expected_check_digit = 11 - remainder
    expected_check_digit = 0 if remainder == 0

    actual_check_digit = kt_string[8].to_i

    return true if expected_check_digit == actual_check_digit
  end
end
