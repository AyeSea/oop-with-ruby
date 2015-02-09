class Player
  attr_reader :name

  def initialize
    puts "Please enter your name:"
    @name = gets.chomp.capitalize
  end
end


class ComputerPlayer
  attr_reader :answer

  def initialize
    @answer = []
    generate_answer
  end

  private
  def generate_answer
    4.times { answer << [1, 2, 3, 4, 5, 6].sample }
  end
end


class MainBoard  
  attr_reader :grid, :current_slot
  attr_accessor :row, :col

  def initialize
    @grid = [] 
    @row = 1
    @col = 1
    @current_slot
    create_grid
  end

  def update_slot
    loop do
      puts "Row #{row}, Column #{col} - please enter a number:"
      number = gets.chomp.to_i

      if (1..6).include?(number)
        grid[12 - row][col - 1] = number
        break
      else
        puts "#{number} is not a valid number. Please enter a number from 1 to 6."
      end
    end
  end

  def row_complete?
    @col > 4 ? true : false
  end

  def board_full?
    @row > 12 ? true : false
  end

  private
  def create_grid
    @grid = Array.new(12) { Array.new(4) { " " } }
  end
end


class FeedbackBoard
  attr_accessor :grid, :row

  def initialize
    @grid = Array.new(12) { Array.new(4) { "NONE" } }
    @row = Array.new(4) { "NONE" }
  end
end


class Game
  attr_reader :player, :opponent, :mainboard, :sideboard

  def initialize
    @player = Player.new
    @opponent = ComputerPlayer.new
    @mainboard = MainBoard.new
    @sideboard = FeedbackBoard.new
  end

  def begin
    until mainboard.board_full?
      
      until mainboard.row_complete?
        mainboard.update_slot
        mainboard.col += 1
        show_board
      end

      update_feedback

      if victory?
        puts "You got the correct answer of #{opponent.answer}! YOU WIN!"
        exit
      else
        sideboard.row = sideboard.row.collect { |slot| slot == "NONE" }    
        mainboard.row += 1
        mainboard.col = 1
      end
    end

    puts "You lose! The correct answer was:"
    puts "#{opponent.answer}"
  end

  private
  def update_feedback
    i = 0

    mainboard.grid[12 - mainboard.row].each do |slot|
      if slot == opponent.answer[i]
        sideboard.row[i] = "MATCH"
      elsif opponent.answer.include?(slot)
        sideboard.row[i] = "EXIST"
      else
        sideboard.row[i] = "NONE"
      end

      i += 1
    end

    sideboard.grid[12 - mainboard.row] = sideboard.row
    show_board
    puts
  end

  def victory?
    if sideboard.row.all? { |slot| slot == "MATCH" }
      true
    else
  
      false
    end
  end

  def show_board
    i = 0
    mainboard.grid.each do |row_array|      
      row_array.each do |slot|
        print "| #{slot} |"
      end

      print "   #{sideboard.grid[i]}"
      i += 1
     
      puts
      puts '--------------------'
      puts
    end
  end
end

game1 = Game.new
game1.begin