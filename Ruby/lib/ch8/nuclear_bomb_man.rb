class NuclearBombMan
  attr_accessor :lines, :matched_lines, :matched_columns, :used

  def initialize(lines = [])
    @lines = lines
    @matched_lines = []
    @matched_columns = []
    @used = []
  end

  def bfs(u)
    return false if @used[u]

    @used[u] = true

    # direct match
    @lines[u].each do |v|
      if @matched_columns[v].nil?
        @matched_lines[u] = v
        @matched_columns[v] = u
        return true
      end
    end

    @lines[u].each do |v|
      if bfs(@matched_columns[v])
        @matched_lines[u] = v
        @matched_columns[v] = u
        return true
      end
    end

    false
  end

  def solve
    was_matched = true

    while was_matched

      was_matched = false
      0.upto(@lines.count - 1) { |index| @used[index] = false }

      0.upto(@lines.count - 1) do |index|
        if @matched_lines[index].nil?
          was_matched ||= bfs(index)
        end
      end
    end

    @matched_lines.compact.count
  end
end

input = STDIN
output = STDOUT

number_of_lines, number_of_columns = input.gets().chomp().split.map { |i| i.to_i }
@lines = []
0.upto(number_of_lines - 1) do |line_index|
  line = input.gets().chomp().split()
  @lines[line_index] ||= []
  line.each_with_index do |e, col_index|
    if e == '1'
      @lines[line_index] << col_index
    end
  end
end

output.puts NuclearBombMan.new(@lines).solve
