require "./lib/piece"

class Pawn < Piece
  attr_accessor :color, :symbol

  def set_symbol
    color == "white" ? " \u2659 " : " \u265F "
  end

  def get_black_moves(pieces,current_x,current_y,starting_piece)
    if starting_piece.color=="black"

      current_piece=pieces[current_x+1][current_y]

      if current_piece.nil? && is_legal?(current_x+1,current_y)
        @possible_and_legal_positions<<[current_x+1,current_y]
      end

      if is_legal?(current_x+1,current_y+1) && !pieces[current_x+1][current_y+1].nil? && pieces[current_x+1][current_y+1].color!="black"
        @possible_and_legal_positions<<[current_x+1,current_y+1]
      end

      if is_legal?(current_x+1,current_y-1) && !pieces[current_x+1][current_y-1].nil? && pieces[current_x+1][current_y-1].color!="black"
        @possible_and_legal_positions<<[current_x+1,current_y-1]
      end

    end

  end

  def possible_moves(pieces,current_x,current_y)
    @possible_and_legal_positions.clear

    current_piece=pieces[current_x][current_y]

    get_black_moves(pieces,current_x,current_y,current_piece)

    @possible_and_legal_positions
  end

end
