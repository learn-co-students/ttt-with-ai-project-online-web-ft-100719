module Players
  class Computer < Player

    def move(board)
      available_cells = set_of_token(' ', board)
      new_move = (pick_move(board, available_cells) + 1).to_s
      new_move
    end

    def opposing_token
      self.token == "X" ? "O" : "X"
    end

    def set_of_token(token, board)
      cells_with_token = []
      board.cells.each_with_index{ |cell, index| cells_with_token << index if cell == token }
      cells_with_token
    end

    def two_matches_give_third(array_of_three_elements, other_array)
      difference = array_of_three_elements - other_array

      if difference.size == 1
        difference.first
      else
        nil
      end
    end

    def pick_move(board, available_cells)
      move = block_or_make_winner(board, available_cells)
      return move unless move.nil?

      return 4 if available_cells.include? 4

      move = available_cells.find { |cell| [0, 2, 6, 8].include? cell }

      return move unless move.nil?

      return available_cells.sample
    end

    def winner_or_blocker(available_cells, players_moves)
      Game::WIN_COMBINATIONS.each do |win_combo|
        move = two_matches_give_third(win_combo, players_moves)

        return move if move && (available_cells.include? move)
      end
      nil
    end

    def block_or_make_winner(board, available_cells)
      # if my next move would win, take that.
      # else, if the opponents next move would win, block it.
      # else nil
      move = winner_or_blocker(available_cells, set_of_token(self.token, board))

      return move unless move.nil?

      winner_or_blocker(available_cells, set_of_token(opposing_token, board))
    end

    
  end
end
