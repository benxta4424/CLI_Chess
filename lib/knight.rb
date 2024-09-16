require "./lib/piece"
require "./lib/board"

class Knight < Piece
  attr_accessor :color, :symbol

  KNIGHT_MOVES = [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1]]

  def set_symbol
    color == "white" ? " \u2658 " : " \u265E "
  end

  def is_legal?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def possible_moves(pieces, current_x, current_y)
    possible_and_legal_positions = []
    starting_piece = pieces[current_x][current_y]

    KNIGHT_MOVES.each do |items|
      possible_x = items[0]
      possible_y = items[1]

      x_move = possible_x + current_x
      y_move = possible_y + current_y

      #it skips over the test if the test values are not inbounds
      next unless is_legal?(x_move,y_move)
    
      possible_piece_in_the_way = pieces[x_move][y_move]

      if possible_piece_in_the_way.nil?
        possible_and_legal_positions<<[x_move,y_move]
      elsif possible_piece_in_the_way.color != starting_piece.color
        possible_and_legal_positions << [x_move, y_move]
      end
    end
    possible_and_legal_positions
  end
end
