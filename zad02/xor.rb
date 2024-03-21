# frozen_string_literal: true


def read_from_file(file_path)
  File.read(file_path).strip
rescue Errno::ENOENT
  puts "#{file_path} not found"
end

def write_to_file(file_name, content)
  File.open(file_name, 'w') { |file| file.puts(content) }
end

if ARGV[0] == '-p'
  orig = read_from_file('orig.txt').delete("\n").downcase
  key = read_from_file('key.txt')
  chars_remaining = key.length - 1

  new_text = orig.split('').reduce do |acc, curr|
    if chars_remaining.positive?
      chars_remaining -= 1
      acc + curr
    else
      chars_remaining = key.length - 1
      "#{acc}\n#{curr}"
    end
  end
  write_to_file('plain.txt', new_text + ' ' * chars_remaining)
end

letters = ('a'..'z').to_a

if ARGV[0] == '-e'
  plain = read_from_file('plain.txt').split("\n")
  key = read_from_file('key.txt').split('')

  encrypted_text = plain.reduce('') do |acc, curr|
    acc + curr.chars.map.with_index do |char, index|
      if char == ' '
        char
      else
        new_index = letters.index(char)
        letters[new_index + letters.index(key[index])]
      end
    end.join + "\n"
  end

  write_to_file('crypto.txt', encrypted_text)
end

if ARGV[0] == '-d'
  crypto = read_from_file('crypto.txt').split("\n")
  key = read_from_file('key.txt').split('')

  decrypted_text = crypto.reduce('') do |acc, curr|
    acc + curr.chars.map.with_index do |char, index|
      if char == ' '
        char
      else
        new_index = letters.index(char)
        letters[new_index - letters.index(key[index])]
      end
    end.join + "\n"
  end

  write_to_file('decrypt.txt', decrypted_text)
end
