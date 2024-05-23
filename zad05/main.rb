# frozen_string_literal: true

# Wiktor Szymulewicz

def hex_to_bin(hex_str)
  hex_str.to_i(16).to_s(2).rjust(hex_str.length * 4, '0')
end

def count_diff_bits(hash1, hash2)
  bin1 = hex_to_bin(hash1)
  bin2 = hex_to_bin(hash2)
  bin1.chars.zip(bin2.chars).count { |b1, b2| b1 != b2 }
end

lines = File.readlines('hash.txt').map(&:strip)

results = (0...lines.size).step(2).map do |i|
  hash1 = lines[i].split.first
  hash2 = lines[i + 1].split.first
  diff_bits = count_diff_bits(hash1, hash2)
  total_bits = hash1.length * 4
  [hash1, hash2, diff_bits, total_bits]
end

File.open('diff.txt', 'w') do |f|
  results.each do |hash1, hash2, diff_bits, total_bits|
    percentage_diff = (diff_bits.to_f / total_bits) * 100
    f.puts hash1
    f.puts hash2
    f.puts "Liczba rozniacych sie bitow: #{diff_bits} z #{total_bits}, procentowo: #{percentage_diff.round}%"
    f.puts ''
  end
end
