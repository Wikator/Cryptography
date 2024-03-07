# frozen_string_literal: true

require_relative 'crypto_base'

# Class for encrypting and decrypting text using the affine cipher
class Affine < CryptoBase
  attr_reader :keys1

  def initialize
    super
    @keys1 = [1, 3, 5, 7, 9, 11, 15, 17, 19, 21, 23, 25]
  end

  def encrypt(text, keys)
    text.split('').reduce('') { |acc, curr| acc + encrypt_letter(curr, keys) }
  end

  def decrypt(text, keys)
    text.split('').reduce('') { |acc, curr| acc + decrypt_letter(curr, keys) }
  end

  def brute_force_decrypt(text, helper)
    text_first_two_letters = text[0, 2]
    @keys1.reduce(nil) do |acc1, key1|
      return acc1 unless acc1.nil?

      (0...26).reduce(nil) do |acc2, key2|
        return acc2 unless acc2.nil?

        decrypted_text = decrypt(text_first_two_letters, { key1:, key2: })
        { key1:, key2: } if decrypted_text == helper[0, 2]
      end
    end
  end

  private

  def encrypt_letter(letter, keys)
    if @uppercase_letters.include?(letter)
      @uppercase_letters[(keys[:key1] * @uppercase_letters.index(letter) + keys[:key2]) % 26]
    elsif @lowercase_letters.include?(letter)
      @lowercase_letters[(keys[:key1] * @lowercase_letters.index(letter) + keys[:key2]) % 26]
    else
      letter
    end
  end

  def decrypt_letter(letter, keys)
    if @uppercase_letters.include?(letter)
      @uppercase_letters[(mod_inverse(keys[:key1], 26) * (@uppercase_letters.index(letter) - keys[:key2])) % 26]
    elsif @lowercase_letters.include?(letter)
      @lowercase_letters[(mod_inverse(keys[:key1], 26) * (@lowercase_letters.index(letter) - keys[:key2])) % 26]
    else
      letter
    end
  end

  def mod_inverse(num, mod)
    (1..mod).each do |i|
      return i if (num * i) % mod == 1
    end
  end
end
