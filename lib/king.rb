require "./lib/piece"

class King < Piece
  attr_accessor :color, :symbol

  def set_symbol
    color == "white" ? " \u2654 " : " \u265A "
  end

  def get_king_moves(pieces, current_x, current_y, x_case, y_case, starting_piece)
    starting_piece = pieces[current_x][current_y]

    x_axis = current_x + x_case
    y_axis = current_y + y_case

    return unless is_legal?(x_axis,y_axis)

    current_piece = pieces[x_axis][y_axis]

    if current_piece.nil?
      @possible_and_legal_positions << [x_axis, y_axis]
      elsif current_piece.color != starting_piece.color
      @possible_and_legal_positions << [x_axis, y_axis]
    end
    @possible_and_legal_positions
  end

  def possible_moves(pieces,current_x,current_y)
    @possible_and_legal_positions.clear

    current_piece=pieces[current_x][current_y]
    get_king_moves(pieces, current_x, current_y, 0, 1, current_piece)
    get_king_moves(pieces, current_x, current_y, 0, -1, current_piece)
    get_king_moves(pieces, current_x, current_y, 1, 0, current_piece)
    get_king_moves(pieces, current_x, current_y, -1, 0, current_piece)
    get_king_moves(pieces, current_x, current_y, 1, 1, current_piece)
    get_king_moves(pieces, current_x, current_y, -1, 1, current_piece)
    get_king_moves(pieces, current_x, current_y, 1, -1, current_piece)
    get_king_moves(pieces, current_x, current_y, -1, -1, current_piece)
    
    @possible_and_legal_positions

  end
end
