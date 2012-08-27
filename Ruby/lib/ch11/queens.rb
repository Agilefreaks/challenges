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
    current_board = board.dup
    current_column = -1
    current_line = 0

    while true
      current_line, current_column = move_next(current_line, current_column)

      if !current_line.nil? && can_place?(current_board, current_line, current_column)
        stack.push({ :board => current_board.dup, :line => current_line, :column => current_column })
        current_board = place(current_board, current_line, current_column)
        result += 1
      elsif current_line.nil? && !stack.empty?
        triplet = stack.pop
        current_board = triplet[:board]
        current_line = triplet[:line]
        current_column = triplet[:column]
      elsif stack.empty?
        break
      end
    end

    result
  end

  def can_place?(board, line, column)
    # search current line
    return false if board[line] != 0

    # debug information
    #p "#{current_line}: #{position1} #{column} #{position3}"
    #p board[current_line] & line_mask.to_i(2)

    # search up
    current_line = line
    while current_line >= 0
      position1 = column - (line - current_line)
      position3 = column + (line - current_line)

      line_mask = "0" * number_of_columns

      line_mask[position1] = "1" if position1 >= 0
      line_mask[position3] = "1" if position3 < @number_of_columns
      line_mask[column] = "1"

      return false if board[current_line] & line_mask.to_i(2) != 0

      current_line -= 1
    end

    # search down
    current_line = line
    while current_line < @number_of_lines
      position1 = column - (current_line - line)
      position3 = column + (current_line - line)

      line_mask = "0" * number_of_columns

      line_mask[position1] = "1" if position1 >= 0
      line_mask[position3] = "1" if position3 < @number_of_columns
      line_mask[column] = "1"

      return false if board[current_line] & line_mask.to_i(2) != 0

      current_line += 1
    end

    true
  end

  def place(board, line, column)
    board[line] |= ("0" * column + "1" + "0" * (number_of_columns - column - 1)).to_i(2)
    board
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
end