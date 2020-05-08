class Board
  attr_accessor :cells

  def reset!
    self.cells = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
  end

  def initialize
    reset!
  end

  def format_row(row_array)
    " #{row_array[0]} | #{row_array[1]} | #{row_array[2]} "
  end

  def display_line
    puts '-----------'
  end

  def display
    # displays the board in the proper format, by displaying all 3 lines
    3.times do |index|
      # first call will print cells 0 - 2, then 3-5, then 6-8
      puts format_row(cells[(index * 3)..((index * 3) + 2)])
      display_line unless index >= 2
    end
  end

  def input_to_index(input_string)
    input_string.strip.to_i - 1
  end

  def position(user_input)
    index = input_to_index(user_input)

    cells[index] if (index >= 0) && (index <= 8)
  end

  def full?
    cells.all?{ |cell| cell != ' ' }
  end

  def turn_count
    cells.reduce(0) do |turn, position|
      turn += 1 if position != " "
      turn
    end
  end

  def taken?(position_string)
    position = input_to_index(position_string)
    cells[position] == 'X' || cells[position] == 'O'
  end

  def valid_move?(move_string)
    move = input_to_index(move_string)

    move >= 0 && move <= 8 && !taken?(move_string)
  end

  def update(user_input, player)
    move = input_to_index(user_input)
    cells[move] = player.token if valid_move?(user_input)
  end
end
