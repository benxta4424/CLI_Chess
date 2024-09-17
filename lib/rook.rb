require "./lib/piece"
require "./lib/board"

class Rook < Piece
  attr_accessor :color, :symbol

  def set_symbol
    @color == "white" ? " \u2656 " : " \u265C "
  end

  # hard coded rook movements
  def possible_moves(pieces, current_x, current_y)
    @possible_and_legal_positions.clear
    starting_piece = pieces[current_x][current_y]

    get_possible_moves(pieces, current_x, current_y, 0, 1, starting_piece)
    get_possible_moves(pieces, current_x, current_y, 0, -1, starting_piece)
    get_possible_moves(pieces, current_x, current_y, 1, 0, starting_piece)
    get_possible_moves(pieces, current_x, current_y, -1, 0, starting_piece)

    @possible_and_legal_positions
  end

  def to_s
    @col == "white" ? @white_rook : @black_rook
  end
end
