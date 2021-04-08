class Game
  attr_accessor :name
  def initialize
    @board = Array.new(9," ").map.with_index {|cell,index| cell = index + 1}
    @player1 = Player.new(name)
    @player2 = Player.new(name)
  end

  WIN_COMBINATIONS = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8,],[0,4,8],[2,4,6]]


  def turn_count
    @board.count {|cell| cell == "X" || cell == "O"}
  end

  def player_marker
    turn_count.even?? "X" : "O"
  end

  def make_move(index)
    @board[index] = player_marker
  end

  def valid_move?(index)
    index.between?(0,8) && !position_taken?(index)
  end

  def position_taken?(index)
    if @board[index] != "X" && @board[index] != "O"
      false
    else
      true
    end
  end

  def current_player
    turn_count.even?? @player1.name : @player2.name
  end

  def opponent
    turn_count.even?? @player2.name : @player1.name
  end

  def turn
    if taken_positions.empty?
      puts "#{current_player} what position would you like to place your token?"
    else
      puts "#{current_player} what position would you like to place your token except position(s) #{taken_positions}"
    end
    input = gets.chomp
    index = input.to_i - 1
    if valid_move?(index)
      make_move(index)
      display_board
    elsif position_taken?(index)
      puts "Position #{input} has been taken by #{player_holding_position(index)}!"
      display_board
      turn
    else
      puts "That's not a valid move"
      display_board
      turn
    end
  end

  def taken_positions
    positions = []
    @board.each_with_index do |cell, indx|
      if cell == "X" || cell == "O"
        positions << (indx + 1)
      end
    end
    positions.join(", ")
  end

  def player_holding_position(index)
    if @board[index] == player_marker
      return "You"
    else
      return opponent
    end
  end

  def display_board
    puts " #{@board[0]}  | #{@board[1]} | #{@board[2]} "
    puts "-------------"
    puts " #{@board[3]}  | #{@board[4]} | #{@board[5]} "
    puts "-------------"
    puts " #{@board[6]}  | #{@board[7]} | #{@board[8]} "
  end

  def draw?
    full? && !won?
  end

  def won?
    WIN_COMBINATIONS.find do |win_combo|
      win_combo.all? {|cell| @board[cell] == "X" } || win_combo.all? {|cell| @board[cell] == "O"}
    end
  end

  def winner
    if current_player == @player2.name
      @player1.name
    elsif current_player == @player1.name
      @player2.name
    end
  end

  def game_over?
    won? || draw?
  end

  def full?
    @board.all? {|cell| cell == "X" || cell == "O"}
  end

  def prompt_player
    puts "Welcome to TICTACTOE"
    puts "--------------------\n"
    puts "First player, what would you like to be called?"
    first_player = gets.chomp.capitalize
    while first_player == ""
      puts "Pls first player input a valid name"
      first_player = gets.chomp.capitalize
    end
    puts "\nSecond player, what would you like to be called?"
    second_player = gets.chomp.capitalize
    while second_player == "" || second_player == first_player
      puts "Pls second player input a valid name"
      second_player = gets.chomp.capitalize
    end
    players = [first_player,second_player].shuffle
    @player1.name = players[0]
    @player2.name = players[1]
    puts "\nA lot has been drawn, #{@player1.name} starts and is assigned the token 'X', while #{@player2.name} goes next and is assigned the token 'O', GOODLUCK!"
  end

  def play
    prompt_player
    display_board
    until game_over? do
      turn
    end
    if won?
      puts "Congratulations #{winner}, you won!, better luck next time #{current_player}"
    elsif draw?
      puts "It's a draw mates"
    end
  end
end

class Player
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

game_status = "y"
while game_status == "y"
  tictactoe = Game.new
  tictactoe.play
  puts "\nThat was a lovely game right? Enter 'y' if you would like to go another round else enter something else"
  game_status = gets.chomp.downcase
end
puts "\nThanks for playing :)"
