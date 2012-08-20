class Queens
  attr_accessor :columns, :lines, :board

  def initialize(columns = 1, lines = 1)
    @columns = columns
    @lines = lines
    @board = []
  end

  def add_line(line)
    @board << line.split('').map { |c| c == "." ? 0 : 1 }.join.to_i(2)
  end

  def calculate
    result = columns * lines

    number_of_queens = 2

    current_board = board.clone

    number_of_queens.times do
      placed = false

      current_board.each_with_index do |line, index|
        mask = ("1" + "0" * (columns - 1)).to_i(2)
        while line & mask == 0 && # can place
            board[index] & mask == 0 && # no obstacle
            mask != 0 # we are not done
          mask >>= 1
        end

        if mask != 0
          # we placed the queen
          placed = true

          # mark all attacked squares
          mark_attacked(line, column, current_board)
        end
      end

      break unless placed
    end

    result
  end

  def mark_attacked(line, column, current_board)
    # mark the line

    # mark the column

    # mark the verticals
  end
end