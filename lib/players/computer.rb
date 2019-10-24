module Players
  class Computer < Player

    def move(board)
      available_cells = []
      board.cells.each_with_index{ |cell, index| available_cells << index if cell == ' ' }
      new_move = (available_cells.sample + 1).to_s
      new_move
    end
  end
end
