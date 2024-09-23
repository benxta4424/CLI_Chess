require "colorize"
require "./lib/piece"
require "./lib/players"
require "./lib/board"
require "./lib/rook"
require "./lib/knight"
require "./lib/bishop"
require "./lib/queen"
require "./lib/pawn"
require "./lib/king"

class Board
  attr_accessor :board, :first_color, :second_color

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @first_color = :light_white
    @second_color = :light_green
    @pieces = Array.new(8) { Array.new(8) }
    @captured_piece = []
    @player_one = nil
    @player_two = nil
    @current_player = nil
    @black_king_position = [0, 4]
    @white_king_position = [7, 4]

    # getting a legal piece from the pick_piece method
    @legal_x_axis_piece = nil
    @legal_y_axis_piece = nil
    # getting a legal move from the pick_move method
    @legal_x_axis_move = nil
    @legal_y_axis_move = nil
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
      false
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

    current_piece = @pieces[old_x][old_y]

    # get the kings's positions at all times
    if current_piece.is_a?(King)
      if current_piece.color == "white"
        @white_king_position = [new_x, new_y]
      else
        @black_king_position = [new_x, new_y]
      end
    end

    # move the piece on the board
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
      row.each_with_index do |_col, col_ind|
        current_piece = @pieces[row_ind][col_ind]

        next if current_piece.nil? || current_piece.color == king_color

        return true if piece_possible_moves(row_ind, col_ind).include?(king_position)
      end
    end
    false
  end

  def check_mate?(king_color)
    king_position = king_color == "white" ? @white_king_position : @black_king_position

    return false unless king_in_check?(king_color)

    x_move, y_move = king_position
    initial_piece = @pieces[x_move, y_move]

    piece_possible_moves(x_move, y_move).each do |items|
      new_x = items[0]
      new_y = items[1]

      current_king = @pieces[x_move][y_move]

      @pieces[new_x][new_y] = current_king
      @pieces[x_move][y_move] = nil

      unless king_in_check?(king_color)
        @pieces[new_x][new_y] = current_king
        @pieces[x_move][y_move] = nil
        return false
      end

      @pieces[new_x][new_y] = nil
      @pieces[x_move][y_move] = current_king
    end

    true
  end

  def create_players
    colors = %w[white black]
    player_counter = 0

    # first player
    puts "Creating player ONE!\n\n"
    print "Name: "
    name = gets.chomp.to_s
    print "Available colors:  \n"

    colors.each_with_index { |item, index| puts "\n#{index}.#{item}" }

    puts puts
    print "Your choice:"
    choice = gets.chomp.to_i

    # removing the color from the array
    colors.delete_at(choice)

    case choice
    when 0
      choice = "white"
    when 1
      choice = "black"
    end

    @player_one = Players.new(name, choice)
    system("clear")

    # second player
    puts "Creating player TWO!\n\n"
    print "Name: "
    name = gets.chomp.to_s

    puts "The remaining color is: #{colors}"

    # second player has no choice but to play with the color that doesn't get picked
    @player_two = Players.new(name, colors[0])

    system("clear")
  end

  def chose_moves(x_or_y, name_movement)
    print "pick your #{x_or_y} #{name_movement}:"
    gets.chomp.to_i
  end

  def pick_piece
    # legal movements(1) ,logical movements(2) ,movements of the same color(3) and pieces that can move(4)
    loop do
      x_piece = chose_moves("X", "piece")
      y_piece = chose_moves("Y", "piece")

      puts
      # 1
      unless is_legal?(x_piece, y_piece)
        puts "Invalid move! Pick within 0-7 bounds\n\n"
        next
      end

      check_piece = @pieces[x_piece][y_piece]
      # 2 (can't move a non existent piece)
      if check_piece.nil?
        puts "Invalid! There is no piece at x->#{x_piece} : y->#{y_piece}!\n\n"
        next
      end

      # 3
      if check_piece.color != @current_player.color_choice
        puts "Pick a piece of your color,#{@current_player.name}!\n\n"
        next
      end

      # 4
      if piece_possible_moves(x_piece, y_piece).empty?
        puts "The piece at x->#{x_piece}:y->#{y_piece} has no possible moves. Pick again!\n\n"
        next
      end

      @legal_x_axis_piece = x_piece
      @legal_y_axis_piece = y_piece
      break
    end
    true
  end

  def pick_moves
    # movement logic
    loop do
      x_move = chose_moves("X", "move")
      y_move = chose_moves("Y", "move")

      # the selected piece can only move to certain positions and it cannot go anywhere on the map
      unless piece_possible_moves(@legal_x_axis_piece, @legal_y_axis_piece).include?([x_move, y_move])
        puts "Your pick is invalid! You can only chose to go to:#{piece_possible_moves(@legal_x_axis_piece,
                                                                                       @legal_y_axis_piece)}"
        next
      end

      if @pieces[@legal_x_axis_piece][@legal_y_axis_piece].is_a?(King) && king_in_check?(@pieces[@legal_x_axis_piece][@legal_y_axis_piece])
        puts "Move your king sunshine!!"
        
        next
      end

      @legal_x_axis_move = x_move
      @legal_y_axis_move = y_move
      break
    end
    true
  end

  def stalemate?(king_color)
    return false if king_in_check?(king_color)
  
    # Check if any piece of the current player has a valid move
    @pieces.each_with_index do |row, x|
      row.each_with_index do |piece, y|
        next if piece.nil? || piece.color != king_color
  
        return false unless piece_possible_moves(x, y).empty?
      end
    end
  
    true # If no valid moves and not in check, it's stalemate
  end
  

  def play_game
    create_players
    @current_player = @player_one
    piece_choice = nil

    until check_mate?(@current_player.color_choice)

      # first choice + board print at the beggining after players's names and choices
      print_board
      
      puts "#{@current_player.name} pick a #{@current_player.color_choice} piece please\n\n"
      # find a desired piece
      if pick_piece
        # after everything is in order,we can check our piece's possible movements
        visualising_possible_moves(@legal_x_axis_piece, @legal_y_axis_piece)
        print_board
      end

      # pick valid moves for the selected piece above
      if pick_moves
        re_apply_color(@legal_x_axis_piece, @legal_y_axis_piece)
        move_pieces([@legal_x_axis_piece, @legal_y_axis_piece], [@legal_x_axis_move, @legal_y_axis_move])
        print_board
      end

      puts "bobobbb" if king_in_check?(@current_player.color_choice)

      system("clear")

      @current_player = @current_player == @player_one ? @player_two : @player_one
    end

    if check_mate?(@current_player.color_choice)
      if @current_player==@player_one
        puts "Player: '#{@player_two.name}' has won via CheckMate!"
      else
        puts "Player: '#{@player_one.name}' has won via CheckMate!"
      end
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
