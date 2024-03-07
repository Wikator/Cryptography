# frozen_string_literal: true

require_relative 'caesar'
require_relative 'affine'

def plain_text_from_file
  file_path = 'plain.txt'
  File.read(file_path).strip
rescue Errno::ENOENT
  puts 'plain.txt not found'
end

def encrypted_text_from_file
  file_path = 'crypto.txt'
  File.read(file_path).strip
rescue Errno::ENOENT
  puts 'crypto.txt not found'
  exit
end

def keys_from_file
  file_path = 'key.txt'
  line = File.read(file_path).strip.split(' ')
  { key1: line[0].to_i, key2: line[1].to_i }
rescue Errno::ENOENT
  puts 'key.txt not found'
end

def helper_from_file
  file_path = 'extra.txt'
  File.read(file_path).strip
rescue Errno::ENOENT
  puts 'extra.txt not found'
end

def write_to_file(file_name, content)
  File.open(file_name, 'w') { |file| file.puts(content) }
end

if ARGV.length != 2
  puts 'Invalid number of arguments. Example usage: ruby main.rb [-c -a] [-e -d -j -k]'
  exit
end

case ARGV[0]
when '-c'
  caesar = Caesar.new
  case ARGV[1]
  when '-e'
    key = keys_from_file[:key1]

    if key < 1 || key > 25
      puts 'Invalid key1. Key1 must be in range [1, 25]'
      exit
    end

    encrypted_text = caesar.encrypt(plain_text_from_file, key)
    write_to_file('crypto.txt', encrypted_text)
  when '-d'
    key = keys_from_file[:key1]

    if key < 1 || key > 25
      puts 'Invalid key1. Key1 must be in range [1, 25]'
      exit
    end

    decrypted_text = caesar.decrypt(encrypted_text_from_file, key)
    write_to_file('decrypt.txt', decrypted_text)
  when '-j'
    encrypted_text = encrypted_text_from_file
    helper = helper_from_file
    if helper.nil? || helper.empty?
      p 'Helper text not found or too short. It needs to be at least 1 character long.'
      exit
    end
    key = caesar.brute_force_decrypt(encrypted_text, helper)
    write_to_file('decrypt.txt', caesar.decrypt(encrypted_text, key))
    write_to_file('key-new.txt', key)
  when '-k'
    encrypted_text = encrypted_text_from_file
    text = (0...25).reduce('') do |acc, key|
      decrypted_text = caesar.decrypt(encrypted_text, key)
      acc + "#{decrypted_text}\n\n"
    end
    write_to_file('decrypt.txt', text.strip)
  else
    puts 'Invalid second argument. Example usage: ruby main.rb [-c -a] [-e -d -j -k]'
  end
when '-a'
  affine = Affine.new
  case ARGV[1]
  when '-e'
    keys = keys_from_file

    if keys[:key1].gcd(26) != 1
      puts 'Invalid key1. Key1 must be coprime with 26'
      exit
    end

    encrypted_text = affine.encrypt(plain_text_from_file, keys)
    write_to_file('crypto.txt', encrypted_text)
  when '-d'
    keys = keys_from_file

    if keys[:key1].gcd(26) != 1
      puts 'Invalid key1. Key1 must be coprime with 26'
      exit
    end

    decrypted_text = affine.decrypt(encrypted_text_from_file, keys_from_file)
    write_to_file('decrypt.txt', decrypted_text)
  when '-j'
    encrypted_text = encrypted_text_from_file
    helper = helper_from_file
    if helper.nil? || helper.length < 2
      p 'Helper text not found or too short. It needs to be at least 2 characters long.'
      exit
    end
    keys = affine.brute_force_decrypt(encrypted_text, helper)
    if keys.nil?
      p 'No valid keys found'
      exit
    end
    write_to_file('decrypt.txt', affine.decrypt(encrypted_text, keys))
    write_to_file('key-new.txt', "#{keys[:key1]} #{keys[:key2]}")
  when '-k'
    encrypted_text = encrypted_text_from_file
    text = affine.keys1.reduce('') do |acc1, key1|
      (0...26).reduce(acc1) do |acc2, key2|
        decrypted_text = affine.decrypt(encrypted_text, { key1:, key2: })
        acc2 + "#{decrypted_text}\n\n"
      end
    end
    write_to_file('decrypt.txt', text.strip)
  else
    puts 'Invalid second argument. Example usage: ruby main.rb [-c -a] [-e -d -j -k]'
  end
else
  puts 'Invalid first argument. Example usage: ruby main.rb [-c -a] [-e -d -j -k]'
end
