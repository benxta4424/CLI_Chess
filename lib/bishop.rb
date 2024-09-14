require "./lib/piece"
require "./lib/board"

class Bishop < Piece
  attr_accessor :color, :symbol

  BISHOP_MOVES = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

  def set_symbol
    color == "white" ? " \u2657 " : " \u265D "
  end

  def is_legal?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def possible_moves(pieces, current_x, current_y)
    switch = true
    possible_and_legal_positions = []
    starting_piece = pieces[current_x][current_y]

    x_axis = current_x
    y_axis = current_y

    # moving towards bottom right corner
    while x_axis < 8 && y_axis < 8

      # first case [1,1]
      if switch
        x_axis = current_x + 1
        y_axis = current_y + 1

        switch = false
      end

      current_piece = pieces[x_axis][y_axis]

      # if a piece is found in the Bishop's path we do the following:
      if !current_piece.nil?
        # we capture the piece if the piece that's in the path of the Bishop is of a different color from the bishop
        if current_piece.color != starting_piece.color && is_legal?(x_axis, y_axis)
          possible_and_legal_positions << [x_axis, y_axis]
          break
        # we stop before the piece that's in the path of the bishop if the piece is of the same color
        elsif current_piece.color == starting_piece.color
          possible_and_legal_positions << [x_axis - 1, y_axis - 1]
          break
        end

      # if we reach the bottom corner with no piece in the path,we can choose to go there if we want to as it's free
      elsif current_piece.nil? && x_axis == 7 && y_axis == 7
        possible_and_legal_positions << [7, 7]
        break
      end

      x_axis += 1
      y_axis += 1
    end

    switch = true

    possible_and_legal_positions
  end
end
