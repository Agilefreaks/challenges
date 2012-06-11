require "benchmark"

class Node
  attr_accessor :value, :occurrences, :children_count, :right, :left, :parent

  def initialize(value, occurrences = 1)
    @value = value
    @occurrences = occurrences
    @children_count = 0
  end
end

class InsertSort
  def number_of_swaps(input)
    # skip over the number of elements
    input.gets()
    array = input.gets().split.map { |n| Node.new(n.to_i, 1) }
    tree = array.shift
    result = 0

    while array.size > 0
      e = array.shift
      root = tree
      parent = tree
      until root.nil? do
        if root.value < e.value
          parent = root
          root = root.right
        elsif root.value > e.value
          parent = root
          result += root.occurrences

          # add right child occurrences
          result += root.right.children_count + root.right.occurrences unless root.right.nil?

          root = root.left
        else
          # are equal
          # add right child occurrences
          result += root.right.children_count + root.right.occurrences unless root.right.nil?

          break
        end
      end

      if root
        root.occurrences += 1
      else
        parent.right = e if parent.value < e.value
        parent.left = e if parent.value > e.value
        e.parent = parent
        root = e
      end

      # increment children count
      parent = root.parent
      until parent.nil?
        parent.children_count += 1
        parent = parent.parent
      end
    end

    result
  end
end

time = Benchmark.measure do
  #input = STDIN
  input = File.new("input03.txt", "r")
  number_of_test_cases = input.gets.chomp().to_i
  insert_sort = InsertSort.new

  number_of_test_cases.times do
    STDOUT.puts insert_sort.number_of_swaps(input)
  end
end

puts time