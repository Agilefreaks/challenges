class InsertSort
  def number_of_swaps(input)
    # skip over the number of elements
    input.gets()
    array = input.gets().split.map { |n| n.to_i }
    result = 0

    array.each_with_index do |e, i|
      (i - 1).downto(0) do |j|
        if array[j] > e
          result +=1
        end
      end
    end

    result
  end
end

#input = STDIN
input = File.new("input01.txt", "r")
number_of_test_cases = input.gets.chomp().to_i
insert_sort = InsertSort.new

number_of_test_cases.times do
  # ignore the number of inputs
  STDOUT.puts insert_sort.number_of_swaps(input)
end