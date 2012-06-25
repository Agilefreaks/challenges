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
    @swap_matrix[index1, index2] == 0 ? false : true
  end

  def fill_swap_matrix
    0.upto(@swap_matrix.row_size - 1) do |k|
      0.upto(@swap_matrix.row_size - 1) do |i|
        0.upto(@swap_matrix.row_size - 1) do |j|
          if @swap_matrix[i, k] == 1 && @swap_matrix[k, j] == 1
            @swap_matrix[i, j] = 1
          end
        end
      end

    end
  end

  def calibrate
    fill_swap_matrix

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