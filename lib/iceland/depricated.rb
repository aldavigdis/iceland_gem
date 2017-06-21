# frozen_string_literal: true

# Depreciated methods for the Iceland module
module Iceland
  # The postal code data as a Hash object
  POSTAL_CODES = YAML.load_file(File.expand_path('../../postcodes.yml',
                                                 __FILE__))

  # Get an array of hashes with postal_code and locale attributes
  # @deprecated Please use {#PostalCode.list} instead
  #
  # @param [Boolean] include_po_boxes Include postal codes for P.O. boxes
  # @param [Boolean] force_nominative Use the nomative version of locale name
  # @return [Array]
  def all_postal_codes(include_po_boxes = false, force_nominative = false)
    Iceland::PostalCode.list(include_po_boxes, force_nominative)
  end

  # Find the name of locale (city/town/village) by postal code
  # @deprecated Please use {#PostalCode.find_locale} instead
  #
  # @param [Integer, String] postal_code The postal code
  # @param [Boolean] force_nominative Display locale name in nomative form
  # @return [String]
  def locale_by_postal_code(postal_code, force_nominative = false)
    Iceland::PostalCode.find_locale(postal_code, force_nominative)
  end
end
