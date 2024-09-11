require "colorize"
require "./lib/rook"

class Board
  attr_accessor :board, :first_color, :second_color

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @first_color = :light_white
    @second_color = :green
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
    board.each { |row| puts row.join }
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

    # move the rook on the board
    current_piece = @pieces[old_x][old_y]
    current_piece.move_front(board, [old_x, old_y], [new_x, new_y])
    board[new_x][new_y] = current_piece.symbol.colorize(background: color_piece(new_x, new_y))

    @captured_piece << current_piece.symbol unless @pieces[new_x][new_y].nil?

    # move the index in the pieces array
    @pieces[old_x][old_y] = nil
    @pieces[new_x][new_y] = current_piece

    # deleting the old rook from the board
    delete_old_pieces_after_moving(old_x, old_y)
  end

  def delete_old_pieces_after_moving(old_x, old_y)
    # deleting the old rook from the board
    board[old_x][old_y] = "   ".colorize(background: color_piece(old_x, old_y))
  end

  def piece_possible_moves(x_choice, y_choice)
    piece = @pieces[x_choice][y_choice]

    possible_moves = piece.possible_moves(x_choice, y_choice)
  end

  def visualising_possible_moves(x_choice, y_choice)
    piece_possible_moves(x_choice, y_choice).each do |items|
      current_x = items[0]
      current_y = items[1]

      current_piece = @pieces[x_choice][y_choice]

      board[current_x][current_y] = current_piece.symbol.colorize(background: :red)
    end
  end

  def re_apply_color(x_choice, y_choice)
    piece_possible_moves(x_choice, y_choice).each do |items|
      current_x = items[0]
      current_y = items[1]

      current_piece = @pieces[x_choice][y_choice]

      board[current_x][current_y] = current_piece.symbol.colorize(background: color_piece(current_x, current_y))
    end
  end

  def saving_captured_piece
    puts @captured_piece
  end

  def play(select_piece, next_move)
    piece_x = select_piece[0]
    piece_y = select_piece[1]

    next_x = next_move[0]
    next_y = next_move[1]

    visualising_possible_moves(piece_x, piece_y)
    print_board
    re_apply_color(piece_x, piece_y)
    move_pieces([piece_x, piece_y], [next_x, next_y])

    puts

    print_board
  end

  def pieces
    @pieces.each do |items|
      puts items.join
    end
  end
end
