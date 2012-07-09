class Travel
  NOT_SET_COUNT = 10

  attr_reader :roads, :number_of_cities, :initial_amount, :cities

  def initialize(number_of_cities = 0, initial_amount = 0)
    @roads = []
    @number_of_cities = number_of_cities
    @initial_amount = initial_amount
    @cities = []
  end

  def add_road(city1, city2, cost)
    @roads[city1] ||= []
    @roads[city1].push({ :city => city2, :cost => cost })

    @roads[city2] ||= []
    @roads[city2].push({ :city => city1, :cost => cost })
  end

  def add_city(city, value)
    cities[city] = value
    @roads[city] ||= []
  end

  def solve
    max = []
    (1..@number_of_cities).each { |i| max[i] = -1 }

    max[1] = @initial_amount
    max_not_set_count = NOT_SET_COUNT

    until max_not_set_count == 0
      max_set = false

      (1..@number_of_cities).each do |city|
        @roads[city].each do |neighbour|
          if neighbour[:cost] <= max[city]
            local_max = (max[city] - neighbour[:cost] + @cities[neighbour[:city]]) / 2
            if max[neighbour[:city]] < local_max
              max[neighbour[:city]] = local_max
              max_set = true
            end
          end
        end
      end

      if max_set
        max_not_set_count = NOT_SET_COUNT
      else
        max_not_set_count -= 1
      end
    end

    max[@number_of_cities]
  end
end

#input = File.new("input00.txt", "r")
input = STDIN
output = STDOUT

n, m, k = input.gets().chomp().split().map { |value| value.to_i }
travel = Travel.new(n, k)
(1..m).each do
  city1, city2, cost = input.gets().chomp().split().map { |value| value.to_i }
  travel.add_road(city1, city2, cost)
end

values = input.gets().chomp().split().map { |value| value.to_i }
(1..n).each do |i|
  travel.add_city(i, values[i - 1])
end

output.puts travel.solve()
