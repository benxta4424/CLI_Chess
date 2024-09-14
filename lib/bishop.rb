require "./lib/piece"
require "./lib/board"

class Bishop < Piece
  attr_accessor :color, :symbol

  BISHOP_MOVES = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  @possible_and_legal_positions=[]

  def set_symbol
    color == "white" ? " \u2657 " : " \u265D "
  end

  def is_legal?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def get_possible_moves(pieces,current_x,current_y,x_case,y_case,starting_piece)
    starting_piece=pieces[current_x][current_y]

    x_axis = current_x+x_case
    y_axis = current_y+y_case

    while is_legal?(x_axis,y_axis)
      current_piece = pieces[x_axis][y_axis]

      if !current_piece.nil?

        if current_piece.color != starting_piece.color && is_legal?(x_axis, y_axis)
          @possible_and_legal_positions << [x_axis, y_axis]
          break
        elsif current_piece.color == starting_piece.color
          @possible_and_legal_positions << [x_axis - x_case, y_axis - y_case]
          break
        end

      elsif x_axis==7 || y_axis==7 || x_axis==0 || y_axis==0
        @possible_and_legal_positions << [x_axis, y_axis]
        break
      end

      x_axis += x_case
      y_axis += y_case
    end

    @possible_and_legal_positions
  end

  def possible_moves(pieces, current_x, current_y)
    
  end
end
