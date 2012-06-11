class InsertSort
  def number_of_swaps(input)
    # skip over the number of elements
    input.gets()
    array = []
    result = 0

    input.gets().split.each do |n|
      number = n.to_i
      array.each do |existing|
        if existing > number
          result +=1
        end
      end

      array << number
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
  STDOUT.puts insert_sort.sort(input)
end