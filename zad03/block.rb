# frozen_string_literal: true

# Wiktor Szymulewicz

# Class for encrypting bmp images to ECB and CBC modes
class EncryptBmp
  def initialize(input_filename, key)
    File.open(input_filename, 'rb') do |file|
      @bmp_header = file.read(54)
      @image_data = file.read.bytes
    end

    @key = key
    @shuffled_bytes = (0..255).to_a.shuffle(random: Random.new(256))
  end

  def encrypt_to_ecb(output_filename, block_size = 16)
    data = get_data(block_size)
    encrypted = data.each_slice(block_size).flat_map do |block|
      block_encrypt(block, block_size)
    end

    save_to_file(output_filename, encrypted.pack('C*'))
  end

  def encrypt_to_cbc(output_filename, initial_vector, block_size = 16)
    data = get_data(block_size)
    encrypted = []
    previous_block = initial_vector
    data.each_slice(block_size) do |block|
      block = block.each_with_index.map { |b, i| b ^ previous_block[i].ord }
      encrypted_block = block_encrypt(block, block_size)
      encrypted.concat(encrypted_block)
      previous_block = encrypted[-block_size..]
    end

    save_to_file(output_filename, encrypted.pack('C*'))
  end

  private

  def create_substitution(data)
    data.map { |byte| @shuffled_bytes[byte % 256] }
  end

  def get_data(block_size = 16)
    @image_data + [0] * ((block_size - @image_data.length % block_size) % block_size)
  end

  def block_encrypt(data, block_size = 16)
    raise 'Invalid data length' if data.length % block_size != 0

    data.each_slice(block_size).flat_map do |block|
      create_substitution(block).map.with_index do |byte, i|
        byte ^ @key[i % @key.length].ord
      end
    end
  end

  def save_to_file(output_filename, encrypted_bytes)
    File.open(output_filename, 'wb') do |file|
      file.write(@bmp_header)
      file.write(encrypted_bytes)
    end
  end
end

key = 'test_key'
iv = 'test_initial_vector'
encrypt_bmp = EncryptBmp.new('plain.bmp', key)

puts 'Encrypting...'
encrypt_bmp.encrypt_to_ecb('ecb_crypto.bmp')
puts 'Successfully encrypted to ECB'
encrypt_bmp.encrypt_to_cbc('cbc_crypto.bmp', iv)
puts 'Successfully encrypted to CBC'
