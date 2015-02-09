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


  def fill_row
    until row_complete?
      update_slot
      @col += 1
      show_mainboard
    end
  end

  def update_slot
    puts "Row #{row}, Column #{col} - please enter a number:"
    number = gets.chomp
    grid[12 - row][col - 1] = number
  end

  def row_complete?
    @col > 4 ? true : false
  end

  def board_full?
    @row > 12 ? true : false
  end

  def victory
    puts "You guessed the opponent's row! You win!"
  end


  private
  def create_grid
    @grid = Array.new(12) { Array.new(4) {" "} }
  end

  def show_mainboard
    @grid.each do |row_array|      
      
      row_array.each do |slot|
        print "| #{slot} |"
      end

      puts
      puts '--------------------'
      puts
    end
  end

end


class FeedbackBoard
  attr_accessor :grid

  def initialize
    @grid = Array.new(4) {"NONE"}
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
      mainboard.fill_row

      compare_to_answer

      if victory?
        puts "You got the correct answer of #{opponent.answer}! YOU WIN!"
        exit
      else
        mainboard.row += 1
        mainboard.col = 1
      end
    end

    puts "You lose! The correct answer was:"
    puts "#{opponent.answer}"
  end

  private
  def compare_to_answer 
    i = 0

    mainboard.grid[12 - mainboard.row].each do |slot|
      slot = slot.to_i
      if slot == opponent.answer[i]
        sideboard.grid[i] = "MATCH"
      elsif opponent.answer.include?(slot)
        sideboard.grid[i] = "EXIST"
      end

      i += 1
    end

    p "Feedback on Guess: #{sideboard.grid}"
    puts
  end

  def victory?
    if sideboard.grid.all? { |slot| slot == "MATCH" }
      true
    else
      sideboard.grid = sideboard.grid.collect { |slot| slot = "NONE" }
      false
    end
  end
end

game1 = Game.new
game1.begin