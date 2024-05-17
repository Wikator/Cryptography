# frozen_string_literal: true

# Wiktor Szymulewicz

require 'prime'

def is_prime(n, k = 5)
  return false if n < 2
  return true if [2, 3].include?(n)
  return false if (n % 2).zero? || (n % 3).zero?

  r = 0
  s = n - 1
  while (s % 2).zero?
    s /= 2
    r += 1
  end

  k.times do
    a = rand(2..n - 2)
    x = a.pow(s, n)
    next if x == 1 || x == n - 1

    (r - 1).times do
      x = x.pow(2, n)
      return false if x == 1
      break if x == n - 1
    end

    return false if x != n - 1
  end

  true
end

def find_factor_with_exp(n, exp, k = 5)
  return n if n < 2
  return 2 if n.even?

  r = 0
  s = exp

  while (s % 2).zero?
    s /= 2
    r += 1
  end

  k.times do
    a = rand(2..n - 2)
    x = a.pow(s, n)
    next if x == 1 || x == n - 1

    (r - 1).times do
      x = x.pow(2, n)
      return n.gcd(x - 1) if x != 1 && x != n - 1
      break if x == n - 1
    end

    gcd = n.gcd(x - 1)
    return gcd if gcd > 1 && gcd < n
  end

  nil
end

def read_input(filepath)
  lines = File.read(filepath).split
  n = lines[0].to_i
  exp = lines[1]&.to_i
  if lines.length > 2
    exp *= lines[2].to_i
    exp -= 1
  end
  [n, exp]
end

def main(filepath, fermat_only)
  n, exp = read_input(filepath)

  if fermat_only
    2.pow(n - 1, n) == 1 ? 'prawdopodobnie pierwsza' : 'na pewno zlożona'
  else
    return 'prawdopodobnie pierwsza' if is_prime(n)

    if exp
      factor = find_factor_with_exp(n, exp)
      return factor if factor && factor != 1
    end

    (2..Math.sqrt(n)).each do |i|
      return i if (n % i).zero?
    end

    'na pewno zlożona'
  end
end

option = ARGV[0] == '-f' ? ARGV[0] : nil
filepath = 'wejscie.txt'
result = main(filepath, option == '-f')

File.open('wyjscie.txt', 'w') { |output_file| output_file.write(result.to_s) }
