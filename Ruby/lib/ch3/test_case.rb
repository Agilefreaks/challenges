test_case = File.new("input03.txt", "w")

test_case.puts(1)
test_case.puts(100000)
100000.downto(1) do |i|
  test_case.write("#{i} ")
end

test_case.close()