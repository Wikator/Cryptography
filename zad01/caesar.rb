# frozen_string_literal: true

require_relative 'crypto_base'

# Class for encrypting and decrypting text using the Caesar cipher
class Caesar < CryptoBase

  def encrypt(text, key)
    text.split('').reduce('') { |acc, curr| acc + encrypt_letter(curr, key) }
  end

  def decrypt(text, key)
    text.split('').reduce('') { |acc, curr| acc + decrypt_letter(curr, key) }
  end

  def brute_force_decrypt(text, helper)
    text_first_letter_index = @lowercase_letters.index(text[0].downcase)
    helper_first_letter_index = @lowercase_letters.index(helper[0].downcase)
    key = text_first_letter_index - helper_first_letter_index
    key.negative? ? key + 26 : key
  end

  private

  def encrypt_letter(letter, key)
    if @uppercase_letters.include?(letter)
      @uppercase_letters[(@uppercase_letters.index(letter) + key) % 26]
    elsif @lowercase_letters.include?(letter)
      @lowercase_letters[(@lowercase_letters.index(letter) + key) % 26]
    else
      letter
    end
  end

  def decrypt_letter(letter, key)
    if @uppercase_letters.include?(letter)
      @uppercase_letters[(@uppercase_letters.index(letter) - key) % 26]
    elsif @lowercase_letters.include?(letter)
      @lowercase_letters[(@lowercase_letters.index(letter) - key) % 26]
    else
      letter
    end
  end
end
