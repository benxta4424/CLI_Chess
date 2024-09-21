require "colorize"
require "./lib/piece"
require "./lib/players"

class Board
  attr_accessor :board, :first_color, :second_color

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @first_color = :light_white
    @second_color = :light_green
    @pieces = Array.new(8) { Array.new(8) }
    @captured_piece = []
    @player_one=nil
    @player_two=nil
    @king_check=0
    @black_king_position=[0,4]
    @white_king_position=[7,4]
  end

  def draw_board
    board.each_with_index do |row, row_ind|
      row.each_with_index do |_col, col_ind|
        row[col_ind] = if is_even?(row_ind, col_ind)
                         "   ".colorize(background: first_color)
                       else
                         "   ".colorize(background: second_color)
                       end
      end
    end
  end

  def print_board
    # Clears the screen and moves the cursor to the top-left corner
    print "\e[2J"  # Clears the entire screen
    print "\e[H"   # Moves the cursor to the top-left corner

    puts "   0  1  2  3  4  5  6  7"

    board.each_with_index do |row, row_ind|
      print row_ind
      print " "
      print row.join
      print " "
      print row_ind
      puts
    end

    puts "   0  1  2  3  4  5  6  7"
  end

  def pieces
    @pieces.each do |items|
      puts items.join
    end
  end

  def is_even?(ind_one, ind_two)
    (ind_one + ind_two).even?
  end

  def color_piece(ind_one, ind_two)
    is_even?(ind_one, ind_two) ? first_color : second_color
  end

  def is_legal?(ind_one, ind_two)
    if ind_one.between?(0, 7) && ind_two.between?(0, 7)
      return true
    elsif !ind_one.between?(0, 7) || !ind_two.between?(0, 7)
      return false
    else
      return false
    end
  end

  def colorize_square(piece, first_ind, second_ind)
    piece.colorize(background: color_piece(first_ind, second_ind))
  end

  def add_pieces(piece_class, piece_type, add_x, add_y)
    # black_rooks
    first_black_rook = piece_class.new(piece_type)
    @pieces[add_x][add_y] = first_black_rook
    board[add_x][add_y] = first_black_rook.symbol.colorize(background: color_piece(add_x, add_y))
  end

  def move_pieces(old_position, new_position)
    old_x = old_position[0]
    old_y = old_position[1]

    new_x = new_position[0]
    new_y = new_position[1]

    #get the kings's positions at all times
    @black_king_position=[x_position,y_position] if @pieces[x_position][y_position].symbol==" \u265A "

    @white_king_position=[x_position,y_position] if @pieces[x_position][y_position].symbol==" \u2654 "

    @captured_piece << @pieces[new_x][new_y].symbol unless @pieces[new_x][new_y].nil?

    # move the piece on the board
    current_piece = @pieces[old_x][old_y]
    board[new_x][new_y] = current_piece.symbol.colorize(background: color_piece(new_x, new_y))

    # move the index in the pieces array
    @pieces[old_x][old_y] = nil
    @pieces[new_x][new_y] = current_piece

    # deleting the old piece from the board
    delete_old_pieces_after_moving(old_x, old_y)
  end

  def delete_old_pieces_after_moving(old_x, old_y)
    # deleting the old rook from the board
    board[old_x][old_y] = "   ".colorize(background: color_piece(old_x, old_y))
  end

  # a selected pieces's possible moves along the board
  def piece_possible_moves(x_choice, y_choice)
    piece = @pieces[x_choice][y_choice]

    possible_moves = piece.possible_moves(@pieces, x_choice, y_choice)
  end

  # coloring in red the squares where a piece is elligile to move
  def visualising_possible_moves(x_choice, y_choice)
    piece_possible_moves(x_choice, y_choice).each do |items|
      current_x = items[0]
      current_y = items[1]

      current_piece = @pieces[current_x][current_y]

      board[current_x][current_y] = if current_piece.nil?
                                      " ● ".colorize(color: :red, background: color_piece(current_x, current_y))
                                    else
                                      current_piece.symbol.colorize(background: :red)
                                    end
    end
  end

  # re-coloring with the board colors the previous red colored squares
  def re_apply_color(x_choice, y_choice)
    piece_possible_moves(x_choice, y_choice).each do |items|
      current_x = items[0]
      current_y = items[1]

      current_piece = @pieces[current_x][current_y]

      board[current_x][current_y] = if current_piece.nil?
                                      "   ".colorize(background: color_piece(current_x, current_y))
                                    else
                                      current_piece.symbol.colorize(background: color_piece(current_x, current_y))
                                    end
    end
  end

  def saving_captured_piece
    puts @captured_piece
  end

  def king_in_check?(king_color)
    king_position = king_color == "white" ? @white_king_position : @black_king_position
  
    @pieces.each_with_index do |row, row_ind|
      row.each_with_index do |col, col_ind|
        current_piece=@pieces[row_ind][col_ind]

        next if current_piece.nil? || current_piece.color==king_color

        return true if piece_possible_moves(row_ind,col_ind).include?(king_position)
      end
    end
    false
  end
  

  def check_mate?(king_color)
    king_position=king_color== "white" ? @white_king_position : @black_king_position

    return false unless king_in_check?(king_color)

    x_move,y_move=king_position
    initial_piece=@pieces[x_move,y_move]    

    piece_possible_moves(x_move,y_move).each do |items|

      new_x=items[0]
      new_y=items[1]

      current_king=@pieces[x_move][y_move]

      @pieces[new_x][new_y]=current_king
      @pieces[x_move][y_move]=nil

      if !king_in_check?(king_color)
        move_pieces([new_x,new_y],[x_move,y_move])
        return false
      end

      @pieces[new_x][new_y]=nil
      @pieces[x_move][y_move]=current_king

    end

    true

  end

  def create_players
    colors=['white','black']
    player_counter = 0

    # first player
    puts "Creating player ONE!\n\n"
    print "Name: "
    name = gets.chomp.to_s
    print "Available colors:  \n"

    colors.each_with_index{|item,index| puts "\n#{index}.#{item}"}

    puts puts 
    print "Your choice:"
    choice = gets.chomp.to_i

    #removing the color from the array
    colors.delete_at(choice)

    case choice
    when 0
      choice="white"
    when 1
      choice="black"
    end

    @player_one = Players.new(name, choice)
    system("clear")

    # second player
    puts "Creating player TWO!\n\n"
    print "Name: "
    name = gets.chomp.to_s

    puts "The remaining color is: #{colors}"

    #second player has no choice but to play with the color that doesn't get picked
    @player_two = Players.new(name, colors[0])

    system("clear")
  end

  def play_game

    create_players

    current_player=@player_one

    piece_choice=nil

    until check_mate?(current_player.color_choice) 

      #first choice + board print at the beggining after players's names and choices
      print_board
      puts "#{current_player.color_choice} is choosing\n\n"
      #i chose 9 because we can't start with nil and a legal position 
      x_piece,y_piece=9

      #for legal movements and respect the colors for every player turn
      until is_legal?(x_piece,y_piece) && @pieces[x_piece][y_piece].color==current_player.color_choice
        print "X axis of your piece is:"
        x_piece=gets.chomp.to_i

        puts

        print "Y axis of your piece is:"
        y_piece=gets.chomp.to_i

        puts
        puts "Invalid Piece.Your choice should be between the 0-7 bounds. Try again!\n\n\n" unless is_legal?(x_piece,y_piece)
        puts "Pick a piece of your color please,#{current_player.name}!\n\n" unless @pieces[x_piece][y_piece].color==current_player.color_choice
      end
      system("clear")

      visualising_possible_moves(x_piece,y_piece)

      current_player = current_player == @player_one ? @player_two : @player_one
    end
  end

  # Helper method to validate move
  def valid_move?(piece_x, piece_y, next_x, next_y)
    piece_possible_moves(piece_x, piece_y).include?([next_x, next_y])
  end

  # printing the piece
  def pieces
    @pieces.each_with_index do |rows, _rows_ind|
      rows.each_with_index do |_col, col_ind|
        next if rows[col_ind].nil?

        print rows[col_ind].symbol
      end
    end
  end
end
