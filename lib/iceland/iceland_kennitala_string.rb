# frozen_string_literal: true

# Monkey patch for the String class
class String
  # Converts a String to a Kennitala object
  #
  # @return [Kennitala]
  def to_kt
    Iceland::Kennitala.new(self)
  end
end
