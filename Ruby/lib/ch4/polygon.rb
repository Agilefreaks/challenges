require "benchmark"

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Line
  attr_accessor :point1, :point2

  def initialize(point1 = nil, point2 = nil)
    @point1 = point1
    @point2 = point2
  end

  def contains?(point)
    if self.point1.y < self.point2.y
      y_range = (self.point1.y..self.point2.y)
    else
      y_range = (self.point2.y..self.point1.y)
    end
    if self.point1.x < self.point2.x
      x_range = (self.point1.x..self.point2.x)
    else
      x_range = (self.point2.x..self.point1.x)
    end

    (self.point1.x == point.x && y_range.include?(point.y)) ||
        (self.point1.y == point.y && x_range.include?(point.x))
  end
end

class Polygon
  attr_reader :lines, :vertical_lines

  def initialize
    @number_of_lines = []
    @vertical_lines = []
    @max = 0
    @min = 0
  end

  def add_point(point)
    line = @number_of_lines.last || add_line

    was_set = false

    was_set, line.point1 = true, point if line.point1.nil?
    was_set, line.point2 = true, point if line.point2.nil? && !was_set

    unless was_set
      line = add_line(line.point2)
      line.point2 = point
    end

    update_max_min(point)
    update_verticals(line)
  end

  def close
    last = @number_of_lines.last

    line = add_line

    line.point1 = last.point2
    line.point2 = @number_of_lines.first.point1

    update_verticals(line)

    @vertical_lines.sort! { |a, b| a.point1.x <=> b.point2.x }
  end

  def update_max_min(point)
    @max = point.x if point.x > @max
    @min = point.x if point.x < @min
  end

  def update_verticals(line)
    if !line.point2.nil? && line.point1.x == line.point2.x
      @vertical_lines << line
    end
  end

  def add_line(point = nil)
    line = Line.new
    @number_of_lines << line

    line.point1 = point unless point.nil?

    line
  end

  def find_index(list, value)
    index = 0
    lower = 0
    upper = list.size - 1

    while upper >= lower do
      index = (lower + upper) / 2

      if list[index].point1.x == value
        index
        break
      elsif list[index].point1.x < value
        lower = index + 1
      else
        upper = index - 1
      end
    end

    index
  end

  def is_point_in?(point)
    # eliminate the ones outside the max area
    if point.x < @min || point.x > @max
      return false
    end

    intersections = 0
    index = find_index(@vertical_lines, point.x)

    while @vertical_lines[index].point1.x < point.x
      index += 1
    end

    while @vertical_lines[index - 1].point1.x == point.x && index > 0
      index -= 1
    end

    index.upto(@vertical_lines.length - 1) do |i|
      line = @vertical_lines[i]
      if line.point1.x == point.x && line.contains?(point)
        intersections = 1
        break
      end
      intersections += 1 if line.contains?(Point.new(line.point1.x, point.y))
    end

    intersections % 2 != 0
  end
end

time = Benchmark.measure do
  #input = STDIN
  #output = STDOUT
  input = File.new("input05.txt", "r")
  output = File.new("output05.txt", "w")
  number_of_points, number_of_polygons = input.gets.chomp().split.map { |n| n.to_i }
  points = []

  number_of_points.times do
    x, y = input.gets.chomp().split.map { |n| n.to_i }
    points << Point.new(x, y)
  end

  number_of_polygons.times do
    polygon = Polygon.new
    number_of_vertices = input.gets.chomp().to_i

    number_of_vertices.times do
      x, y = input.gets.chomp().split.map { |n| n.to_i }
      polygon.add_point(Point.new(x, y))
    end
    polygon.close

    result = 0
    points.each do |point|
      if polygon.is_point_in?(point)
        result += 1
      end
    end

    output.puts result
  end
end

puts time
