class Queens
  attr_accessor :number_of_columns, :number_of_lines, :board

  def initialize(columns = 1, lines = 1)
    @number_of_columns = columns
    @number_of_lines = lines
    @board = []
  end

  def add_line(line)
    @board << line.split('').map { |c| c == "." ? 0 : 1 }.join.to_i(2)
  end

  def calculate
    result = 0

    stack = []
    current_board = board
    current_column = 0
    current_line = 0

    if can_place?(current_board, current_line, current_column)
      place(current_board, current_line, current_column)
      result += 1
      stack.push({ :board => current_board, :line => current_line, :column => current_column })
    end

    current_line, current_column = move_next(current_line, current_column)

    # add a queen on the next free position
    # test if it's valid
    # count the solution
    # cary on

    result
  end

  def can_place?(board, line, column)
    true
  end

  def move_next(line, column)
    if column < @number_of_columns - 1
      column += 1
    elsif line < @number_of_lines - 1
      line, column = line + 1, 0
    else
      line, column = nil, nil
    end

    [line, column]
  end

  def mark_attacked(line, column, current_board)
    # mark the line

    # mark the column

    # mark the verticals
  end
end