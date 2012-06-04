require "benchmark"

class Node
  attr_accessor :value, :weight

  def initialize(value, weight)
    @value = value
    @weight = weight
  end
end

class SubsequentWeighting
  attr_reader :tuplets

  def initialize
    @tuplets = []
  end

  def add_values(input)
    input.each do |value|
      tuplets << {:value => value.to_i()}
    end
  end

  # expect add_values to be called first with the same n
  def add_weights(input)
    input.length.times do |i|
      tuplets[i][:weight] = input[i].to_i()
    end
  end

  def parse
    root = Node.new(0, 0)
    maxim = 0

    tuplets.each do |tuplet|
      stack = []
      stack.push(root)
      best_child = root

      until stack.empty? do
        child = stack.pop

        child.children.each do |grand|
          if grand.value < tuplet[:value]
            stack.push grand
          end
        end

        if child.value < tuplet[:value] && best_child.total < child.total
          best_child = child
        end
      end

      node = Node.new(tuplet[:value], tuplet[:weight])
      node.total = best_child.total + tuplet[:weight]

      maxim = node.total if maxim < node.total

      best_child.children << node
    end

    maxim
  end
end

time = Benchmark.measure do
  #input = STDIN
  input = File.new("input04.txt", "r")
  number_of_test_cases = input.gets.chomp().to_i

  number_of_test_cases.times do
    # ignore the number of inputs
    input.gets.chomp().to_i

    parser = SubsequentWeighting.new
    parser.add_values(input.gets.chomp.split)
    parser.add_weights(input.gets.chomp.split)

    STDOUT.puts parser.parse2
  end
end

puts time
