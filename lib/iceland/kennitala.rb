# The Kennitala Class
class Kennitala
  def initialize(kt_string = false, is_company = false)
    kt_string = fake_kt_string(is_company) if kt_string == false
    unless kt_string.class == String
      raise ArgumentError, 'Kennitala needs to be provided as a String or '\
                           'Boolean (false)'
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
    return 'company' if (date_integer > 40) && (date_integer < 72)
  end

  # Check if the entity is a company
  #
  # @return [Boolean]
  def company?
    date_integer = @value[0, 2].to_i
    return true if (date_integer > 40) && (date_integer < 72)
    false
  end

  # Check if the entity is a person
  #
  # @return [Boolean]
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

  # Pretty print a kennitala
  #
  # Puts a spacer between the 6th and the 7th digit
  #
  # @param [String] spacer A single space by default
  # @return [String]
  def pp(spacer = ' ')
    raise ArgumentError 'Spacer must be a string' unless spacer.class == String
    @value[0, 6] + spacer + @value[6, 9]
  end

  private

  # Generate fake a birth number and check digit based on the first 6 digits
  #
  # @param [String] The first six digits is a kennitala
  # @return [Hash, nil]
  def fake_randoms(date_hash)
    first_six = date_hash[:day] + date_hash[:month] + date_hash[:year]
    loop do
      birth_number = Random.rand(1..99).to_s.rjust(2, '0')
      first_eight = "#{first_six}#{birth_number}"
      check_digit = calculate_check_digit(first_eight)
      if check_checksum(first_eight)
        return { check_digit: check_digit, birth_number: birth_number }
      end
    end
  end

  # Generate a fake year and century Hash
  #
  # @return [Hash]
  def fake_year
    century = [9, 9, 9, 8, 0, 0].sample
    current_year = Date.today.strftime('%y').to_i
    if century == 0
      return { year: Random.rand(0..current_year), century: century }
    else
      return { year: Random.rand(0..99), century: century }
    end
  end

  # Generate a fake hash that includes randomly generated date elements
  #
  # @param [Boolean] is_company true if the day string is for a company
  # @return [Hash]
  def fake_date_hash(is_company = false)
    year_hash = fake_year

    month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    month = Random.rand(1..12)

    day = Random.rand(1..month_days[month - 1])
    day = (day.to_i + 40).to_s.rjust(2, '0') if is_company == true

    { century: year_hash[:century].to_s,
      year: year_hash[:year].to_s.rjust(2, '0'),
      month: month.to_s.rjust(2, '0'), day: day.to_s.rjust(2, '0') }
  end

  # Generate a fake, random kennitala string
  #
  # @param [Boolean] is_company If the kennitala is for a company, not a person
  # @return [String] A 10-digit string representing a kennitala
  def fake_kt_string(is_company = false)
    date_hash = fake_date_hash(is_company)
    randoms_hash = fake_randoms(date_hash)

    first_six = date_hash[:day] + date_hash[:month] + date_hash[:year]
    randoms = randoms_hash[:birth_number].to_s + randoms_hash[:check_digit].to_s

    first_six + randoms + date_hash[:century]
  end

  # Get year from a kennitala string
  #
  # @param [String] kt_string Sanitized kennitala string
  # @return [Fixnum] description of returned object
  def get_year_from_string(kt_string)
    century_code = kt_string[9, 1].to_i
    case century_code
    when 0
      return "20#{kt_string[4, 2]}".to_i
    when 8..9
      return "1#{century_code}#{kt_string[4, 2]}".to_i
    end
  end

  # Sanitize the kennitala
  #
  # @param [String] kt_string Unsanitised string representing a kennitala
  # @return [String, nil] Sanitized kennitala, nil if invalid
  def sanitize(kt_string)
    sanitized_kt = kt_string.gsub(/[^0-9]/, '')
    checks = check_checksum(sanitized_kt)

    year = get_year_from_string(sanitized_kt)
    day = sanitized_kt[0, 2].to_i
    day -= 40 if day > 40
    month = sanitized_kt[2, 2].to_i
    date = Date.new(year, month, day)

    return sanitized_kt if checks == true && date.class == Date

  rescue ArgumentError, 'invalid date'
    nil
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

  # Calculate the check digit for a kennitala
  #
  # @param [String] kt_string Sanitized kennitala
  # @return [Fixnum]
  def calculate_check_digit(kt_string)
    remainder = checksum(kt_string).modulo(11)

    # A kennitala with a remainder of 10 is always considered to be invalid
    return nil if remainder == 10

    # The check digit should be 11 minus the remainder,
    # unless the remainder is 0, then the theck digit becomes 0.
    return 0 if remainder == 0
    11 - remainder
  end

  # Check validity of the check digit
  #
  # @param [String] kt_string Sanitized kennitala
  # @return [Boolean, nil] true on success, false if the check digit is invalid
  def check_checksum(kt_string)
    expected_check_digit = calculate_check_digit(kt_string)
    actual_check_digit = kt_string[8].to_i
    return true if expected_check_digit == actual_check_digit
    false
  end
end
