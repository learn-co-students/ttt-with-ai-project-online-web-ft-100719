require 'bundler'
Bundler.require

require_all 'lib'

class Game
  attr_accessor :board, :player_1, :player_2

  WIN_COMBINATIONS = [
    [0, 1, 2], #top row
    [3, 4, 5], #middle row
    [6, 7, 8], #bottom row
    [0, 3, 6], #first column
    [1, 4, 7], #second column
    [2, 5, 8], #third column
    [0, 4, 8], #top left to bottom right diagonal
    [2, 4, 6] #top right to bottom left diagonal
  ]

  def initialize(player_1 = Players::Human.new('X'),
                 player_2 = Players::Human.new('O'), board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
  end

  def current_player
    @board.turn_count.even? ? @player_1 : @player_2
  end

  def winning_combo?(combination)
    ( combination.all?{|position| @board.cells[position] == 'X'} ||
      combination.all?{|position| @board.cells[position] == 'O'} )
  end

  def won?
    winner = nil
    WIN_COMBINATIONS.each do |combination|
      winner = combination if winning_combo?(combination)
    end
    winner
  end

  def draw?
    @board.full? && !won?
  end

  def over?
    draw? || !!won?
  end

  def winner
    if !!won?
      @board.cells[won?[0]]
    else
      nil
    end
  end

  def turn
    if current_player.is_a? Players::Human
      puts "Where would you like to move? (Enter 1-9):"
      user_input = current_player.move(@board)
      if @board.valid_move?(user_input)
        @board.update(user_input, current_player)
        @board.display
      else
        turn
      end
    else
      puts "The computer's move:"
      @board.update(current_player.move(@board), current_player)
      @board.display
    end
  end

  def play
    until over?
      turn
    end
    if !!won?
      puts "Congratulations #{winner}!"
    elsif draw?
      puts "Cat's Game!"
    end
  end
end
