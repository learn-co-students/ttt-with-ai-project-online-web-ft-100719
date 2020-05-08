# frozen_string_literal: true

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
      puts "Where would #{current_player.name} like to move? (Enter 1-9):"
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

  def self.num_players_valid?(user_input)
    %w[0 1 2].include? user_input
  end

  def self.x_or_o
    user_input = nil
    until %w[X O].include? user_input
      puts "Should the first player use X or O?:"
      user_input = gets.strip
    end
    user_input
  end

  def self.yes_or_no?(input)
    ['y', 'yes', 'n', 'no', ''].include? input
  end

  def self.prompt_yes_or_no?(prompt_for_user)
    user_input = nil
    until yes_or_no?(user_input)
      puts prompt_for_user
      user_input = gets.strip.downcase
    end
    !%w[n no].include? user_input
  end

  def self.player_tokens
    player_1_token = self.x_or_o
    player_2_token = player_1_token == "X" ? "O" : "X"
    [player_1_token, player_2_token]
  end

  def self.player_order(human_name, play_first, tokens)
    if play_first
      player_1 = Players::Human.new(tokens.first, human_name)
      player_2 = Players::Computer.new(tokens.last)
    else
      player_1 = Players::Computer.new(tokens.first)
      player_2 = Players::Human.new(tokens.last, human_name)
    end
    [player_1, player_2]
  end

  def self.start_one_player_game
    puts "Enter your name:"
    human_name = gets.strip
    play_first = prompt_yes_or_no?("Would you like to play first?[Y/n]:")
    tokens = self.player_tokens
    players = player_order(human_name, play_first, tokens)
    Game.new(players[0], players[1], Board.new).play
  end

  def self.start_two_player_game
    puts "Enter the name of the first player:"
    player_1_name = gets.strip
    puts "Enter the name of the second player:"
    player_2_name = gets.strip
    tokens = self.player_tokens

    Game.new(Players::Human.new(tokens.first, player_1_name),
             Players::Human.new(tokens.last, player_2_name), Board.new).play
  end

  def self.start_computer_only_game
    tokens = self.player_tokens
    Game.new(Players::Computer.new(tokens.first),
             Players::Computer.new(tokens.last), Board.new).play
  end

  def self.start_game(num_players)
    case num_players
    when 0
      start_computer_only_game
    when 1
      start_one_player_game
    when 2
      start_two_player_game
    end
  end

  def self.start
    puts "Welcome to Tic Tac Toe!"
    num_players = nil
    until num_players_valid?(num_players)
      puts "How many human players are there?(0, 1, or 2):"
      num_players = gets.strip
    end
    start_game(num_players.to_i)
    if self.prompt_yes_or_no?("Would you like to play again?[Y/n]:")
      self.start
    else
      puts "Thanks for playing! Goodbye!"
    end
  end
end
