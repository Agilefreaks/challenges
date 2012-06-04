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
    list = [root]
    maxim = 0

    tuplets.each do |tuplet|
      index = 0

      (list.length - 1).downto(0) do |i|
        if list[i].value < tuplet[:value]
          index = i
          break
        end
      end

      node = Node.new(tuplet[:value], list[index].weight + tuplet[:weight])
      add = true
      to_be_deleted = []

      (index + 1).upto(list.length - 1) do |i|
        if list[i].value == node.value && list[i].weight >= node.weight
          add = false
          break
        elsif list[i].weight <= node.weight
          to_be_deleted << list[i]
        else
          break
        end
      end

      to_be_deleted.each do |el|
        list.delete(el)
      end

      if add
        list.insert(index + 1, node)
        maxim = node.weight if maxim < node.weight
      end
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

    STDOUT.puts parser.parse
  end
end

puts time
