module Players
  class Computer < Player

    def move(board)
      available_cells = []
      board.cells.each_with_index{ |cell, index| available_cells << index if cell == ' ' }
      available_cells.sample.to_s
    end
  end
end
