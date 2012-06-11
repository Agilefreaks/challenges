require "benchmark"

class Node
  attr_accessor :value, :weight

  def initialize(value, weight)
    @value = value
    @weight = weight
  end
end

class SubsequentWeighting
  attr_reader :nodes

  def initialize
    @nodes = []
  end

  def add_values(input)
    input.each do |value|
      nodes << Node.new(value.to_i(), 0)
    end
  end

  # expect add_values to be called first with the same n
  def add_weights(input)
    input.length.times do |i|
      nodes[i].weight = input[i].to_i()
    end
  end

  def find_index(list, value)
    index = 0
    lower = 0
    upper = list.size - 1

    while upper >= lower do
      index = (lower + upper) / 2

      if list[index].value == value
        index -= 1 if index > 0
        break
      elsif list[index].value < value
        lower = index + 1
      else
        upper = index - 1
      end
    end

    if index == list.length
      index = list.length - 1
    end

    if list[index].value >= value
      index - 1
    else
      index
    end
  end

  def parse
    list = [Node.new(0, 0)]
    maxim = 0

    nodes.each do |node|
      index = find_index(list, node.value)

      node.weight += list[index].weight
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
  input = File.new("input07.txt", "r")
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
