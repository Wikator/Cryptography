# frozen_string_literal: true

# Base class for all crypto classes
class CryptoBase
  def initialize
    @uppercase_letters = ('A'..'Z').to_a
    @lowercase_letters = ('a'..'z').to_a
  end
end
