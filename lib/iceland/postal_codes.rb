# Postal Codes
module Iceland
  POSTAL_CODES = YAML.load_file(File.expand_path('../../postcodes.yml',
                                                 __FILE__))

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
  # @return [String]
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
