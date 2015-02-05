class Player
  attr_reader :name, :mark, :boxes_chosen

  @@player_count = 0

  def initialize
    @@player_count += 1
    @boxes_chosen = []
    name_chooser
    mark_chooser
  end

  def choose_box
    puts "#{name}, please choose a box:"
    box = gets.chomp.to_i
  end

  private  
  def name_chooser
    puts "\nPlayer #{@@player_count}, please enter your name:"
    @name = gets.chomp.capitalize
  end

  def mark_chooser
    @@player_count == 1 ? @mark = 'X' : @mark = 'O'
    puts "\n#{name}, you will play as #{mark}."
  end
end


class Board
  attr_reader :current_board

  def initialize
    @current_board = {}
    create_board
  end

  def show_board
    i = 0
    3.times do
      3.times do 
        i += 1
        print "| #{current_board[i]} |"
      end
      puts
      puts "_______________" if i == 3 || i == 6
    end
  end

  def update_box(box_key, mark)
      current_board[box_key] = mark
  end

  def box_empty?(box_key)
    current_board[box_key] == '-' ? true : false
  end

  private
  def create_board
    9.times do |i|
      current_board[i + 1] = "-"
    end
  end
end


class TicTacToe
  attr_reader :player1, :player2, :board, :box_key

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = Board.new
  end

  def begin
    game_description

    loop do 
      player_turn(player1)
      player_turn(player2)
    end
  end

  private
  def game_description
    puts
    puts "Each box on the board is represented with a number from 1 - 9,"
    puts "where the box in the top-left corner is 1 and the one in the bottom-right corner is 9."
    puts "Think of how numbers are displayed on a typical phonepad."
    puts
  end

  def player_turn(playernum)
    puts "#{playernum.name}'s turn."

    #Loop until win or draw conditions are met.
    loop do 
      puts "Please select a box:"
      @box_key = gets.chomp.to_i
       
      if (1..9).include?(box_key)
        if board.box_empty?(box_key)
          board.update_box(box_key, playernum.mark)
          playernum.boxes_chosen << box_key
          break
        else
          puts "Box #{box_key} is already taken. Please try again."
        end
      else
        puts "Box #{box_key} is not a valid box. Please try again."
      end
    end

    board.show_board
    puts
    if victory?(playernum)
      puts "#{playernum.name} wins!"
      exit
    elsif draw?
      puts "Tie Game!"
      exit
    end
  end

  def victory?(playernum)
    board_now = board.current_board
    mark = playernum.mark

    return true if board_now[1] == mark && board_now[2] == mark && board_now[3] == mark
    return true if board_now[4] == mark && board_now[5] == mark && board_now[6] == mark
    return true if board_now[7] == mark && board_now[8] == mark && board_now[9] == mark
    return true if board_now[1] == mark && board_now[4] == mark && board_now[7] == mark
    return true if board_now[2] == mark && board_now[5] == mark && board_now[8] == mark
    return true if board_now[3] == mark && board_now[6] == mark && board_now[9] == mark
    return true if board_now[1] == mark && board_now[5] == mark && board_now[9] == mark
    return true if board_now[3] == mark && board_now[5] == mark && board_now[7] == mark
    false
  end

  def draw?
    board.current_board.each do |box_key, box_value|
      return false if box_value == '-'
    end
    true
  end
end


first_game = TicTacToe.new
first_game.begin