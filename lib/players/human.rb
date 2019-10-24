require_relative '../player'
module Players
  class Human < Player

    def move(board)
      gets
    end
  end
end
