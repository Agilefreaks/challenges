class Node
  attr_accessor :value, :occurrences, :children_count

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
    tree = []
    result = 0

    array.each do |e|
      i = 1
      until tree[i].nil? do
        if tree[i].value < e.value
          # go right
          i = 2*i + 1
        elsif tree[i].value > e.value
          result += tree[i].occurrences

          # add right child occurrences
          unless tree[2*i + 1].nil?
            result += tree[2*i + 1].children_count + 1
          end

          # go left
          i = 2*i
        else
          # add right child occurrences
          unless tree[2*i + 1].nil?
            result += tree[2*i + 1].children_count + 1
          end

          break
        end
      end

      if tree[i].nil?
        tree[i] = e
      elsif tree[i].value == e.value
        tree[i].occurrences += 1
      end

      # increment children count
      until tree[i / 2].nil?
        tree[i / 2].children_count += 1
        i /= 2
      end
    end

    result
  end
end

input = STDIN
#input = File.new("input02.txt", "r")
number_of_test_cases = input.gets.chomp().to_i
insert_sort = InsertSort.new

number_of_test_cases.times do
  STDOUT.puts insert_sort.number_of_swaps(input)
end
