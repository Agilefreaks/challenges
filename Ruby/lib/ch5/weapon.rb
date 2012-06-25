require "matrix"

class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

class Weapon
  attr_accessor :swap_matrix
  attr_accessor :configuration

  def initialize(size = 3)
    @swap_matrix = Matrix.zero(size)
    @configuration = []
  end

  def can_swap?(index1, index2)
    result = @swap_matrix[index1, index2] == 0 ? false : true

    unless result
      # check for indirect swap
      row1 = @swap_matrix.row(index1)
      row2 = @swap_matrix.row(index2)

      row1.to_a.each_index do |index|
        if row1[index] == 1 && row2[index] == 1
          result = true
          @swap_matrix[index1, index2] = 1
          @swap_matrix[index2, index1] = 1
          break
        end
      end
    end

    result
  end

  def calibrate
    0.upto(@configuration.length - 1) do |i|
      (i + 1).upto(@configuration.length - 1) do |j|
        if @configuration[i] > @configuration[j] && can_swap?(i, j)
          @configuration[i], @configuration[j] = @configuration[j], @configuration[i]
        end
      end
    end

    @configuration
  end
end

#input = File.new("input00.txt", "r")
input = STDIN
output = STDOUT

k = input.gets().chomp().to_i
weapon = Weapon.new(k)
weapon.configuration = input.gets().split().map { |value| value.to_i }
0.upto(k - 1) do |index|
  line = input.gets().chomp()
  0.upto(line.length - 1).each do |i|
    weapon.swap_matrix[index, i] = line[i] == 'N' ? 0 : 1
  end
end

output.puts weapon.calibrate.join(" ")