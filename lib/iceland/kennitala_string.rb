# Monkey patch for the String class
class String
  # Converts a String to a Kennitala object
  #
  # @return [Kennitala]
  def to_kt
    Kennitala.new(self)
  end
end
