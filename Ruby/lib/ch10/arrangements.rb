require "matrix"

class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

class Arrangements
  attr_accessor :matrix, :solution

  def initialize(matrix = nil)
    @matrix = matrix
    @solution = []
  end

  def add(team)
    if @matrix[team, solution[0]] == 1
      @solution.insert(0, team)
    elsif @matrix[solution.last, team] == 1
      @solution.push(team)
    else
      (1..@solution.length - 1).each do |index|
        if @matrix[@solution[index -1], team] == 1 && @matrix[team, @solution[index]] == 1
          @solution.insert(index, team)
          break
        end
      end
    end
  end

  def solve
    solution.push(0)
    (1..@matrix.row_size).each do |team|
      add(team)
    end

    "Yes #{@solution.join(" ")}"
  end
end

input = STDIN
output = STDOUT

number_of_test_cases = input.gets().chomp().to_i

number_of_test_cases.times do
  number_of_teams = input.gets().chomp().to_i
  matrix = Matrix.zero(number_of_teams)
  number_of_teams.times do |line_index|
    line = input.gets().chomp()
    line.split(//).each_with_index do |value, index|
      matrix[line_index, index] = value.to_i
    end
  end
  output.puts(Arrangements.new(matrix).solve())
end