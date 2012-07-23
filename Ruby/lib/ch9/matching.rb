class Matching
  MODULO = 1000000007

  def primes
    Enumerator.new do |g|
      n = 2
      p = []

      while true
        if p.all? { |f| n % f != 0 }
          g.yield n
          p << n
        end
        n += 1
      end
    end
  end

  def solve(n)
    cached_primes = []
    powers = []

    primes.each do |prime|
      break if prime > 2 * n
      cached_primes << prime
    end

    (2..n).each do |k|
      powers = decompose(n + k, cached_primes, powers, true)
      powers = decompose(k, cached_primes, powers, false)
    end

    result = 1

    powers.each_with_index do |power, index|
      (1..power).each do
        result *= cached_primes[index]
        result %= MODULO
      end
    end

    result
  end

  def decompose(n, cached_primes, powers, add = true)
    index = 0
    while n > 1
      powers[index] ||= 0
      while n % cached_primes[index] == 0
        add ? powers[index] += 1 : powers[index] -= 1
        n /= cached_primes[index]
      end
      index += 1
    end

    powers
  end
end

input = STDIN
output = STDOUT

output.puts(Matching.new().solve(input.gets().chomp().to_i))