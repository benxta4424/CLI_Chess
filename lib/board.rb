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
      true
    elsif !ind_one.between?(0, 7) || !ind_two.between?(0, 7)
      false
    else
      raise ArgumentError
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

  def create_new_player(name, color)
    Players.new(name, color)
  end

  def play
    #first player
    puts "Creating player one: "
    print "Name: " 
    name=gets.chomp.to_s
    
    puts

    print "Color choice:"
    choice=gets.chomp.to_s
    
    player1=Players.new(name,choice)

    puts
    puts

    system("clear")

  #second player
    puts "Creating player two: "
    print "Name: " 
    name=gets.chomp.to_s
    
    puts

    print "Color choice:"
    choice=gets.chomp.to_s

    player2=Players.new(name,choice)

    system("clear")


    current_player=player1

      loop do
        visualising_possible_moves(piece_x, piece_y)
        print_board
        re_apply_color(piece_x, piece_y)

        print "add x position: "
        next_x = gets.chomp.to_i
        print "add y position: "
        next_y = gets.chomp.to_i

        if valid_move?(piece_x, piece_y, next_x, next_y)
          move_pieces([piece_x, piece_y], [next_x, next_y])
          switch = true
        else
          puts "Invalid move! Try again."
        end

        break if switch
      end

      print_board
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
      puts
    end
  end
end
