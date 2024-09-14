require "./lib/piece"
require "./lib/board"

class Rook < Piece
  attr_accessor :color, :symbol

  def set_symbol
    @color == "white" ? " \u2656 " : " \u265C "
  end

  def is_legal?(number)
    number.between?(0, 7)
  end

  def possible_moves(pieces, current_x, current_y)
    possible_and_legal_positions = []
    starting_piece = pieces[current_x][current_y]

    starting_x = current_x
    starting_y = current_y

    # checking on the left side of the x axis
    (current_x - 1).downto(0) do |x|
      new_piece = pieces[x][current_y]
      if !new_piece.nil?
        if new_piece.color == starting_piece.color
          possible_and_legal_positions << [x + 1, current_y]
          break
        elsif new_piece.color != starting_piece.color
          possible_and_legal_positions << [x, current_y]
          break
        end

      elsif new_piece.nil? && x == 0
        possible_and_legal_positions << [0, current_y]
      end
    end
    # checking on the right side of the x axis
    (current_x + 1).upto(7) do |x|
      new_piece = pieces[x][current_y]
      if !new_piece.nil?
        if new_piece.color == starting_piece.color
          possible_and_legal_positions << [x - 1, current_y]
          break
        elsif new_piece.color != starting_piece.color
          possible_and_legal_positions << [x, current_y]
          break
        end
      elsif new_piece.nil? && x == 7
        possible_and_legal_positions << [7, current_y]
      end
    end

    # checking upwards on the x axis
    (current_y - 1).downto(0) do |y|
      new_piece = pieces[current_x][y]
      if !new_piece.nil?
        if new_piece.color == starting_piece.color
          possible_and_legal_positions << [current_x, y + 1]
          break
        elsif new_piece.color != starting_piece.color
          possible_and_legal_positions << [current_x, y]
          break
        end
      elsif new_piece.nil? && y == 0
        possible_and_legal_positions << [current_x, 0]
      end
    end

    # going downwards on the y axis
    (current_y + 1).upto(7) do |y|
      new_piece = pieces[current_x][y]
      if !new_piece.nil?
        if new_piece.color == starting_piece.color
          possible_and_legal_positions << [current_x, y - 1]
          break
        elsif new_piece.color != starting_piece.color
          possible_and_legal_positions << [current_x, y]
          break
        end
      elsif new_piece.nil? && y == 7
        possible_and_legal_positions << [current_x, 7]
      end
    end

    possible_and_legal_positions
  end

  def to_s
    @col == "white" ? @white_rook : @black_rook
  end
end
