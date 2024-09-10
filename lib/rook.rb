require "colorize"

class Rook

  attr_accessor :color, :symbol

  def initialize(color)
    @col = color
    @white_rook = " \u2656 "
    @black_rook = " \u265C "
    @symbol = color == "white" ? @white_rook : @black_rook
  end

  def check_color
    if @col == "white"
      @white_rook
    elsif @col == "black"
      @black_rook
    end
  end

  def colorize_rook(piece, color)
    piece.colorize(background: color)
  end

  def is_legal?(number)
    number.between?(0,7)
  end

  def possible_moves(current_x,current_y)
    possible_and_legal_positions=[]
    rook_movements = [[0, current_y], [7, current_y], [current_x, 0], [current_x, 7]]

    rook_movements.each do |items|
        x_movement=items[0]
        y_movement=items[1]

        possible_and_legal_positions<<[x_movement,y_movement] if [x_movement,y_movement]!=[current_x,current_y]
    end

    possible_and_legal_positions

  end

  def move_front(board, old_position, new_position)
    old_x = old_position[0]
    old_y = old_position[1]

    new_x = new_position[0]
    new_y = new_position[1]

    board[new_x][new_y] = board[old_x][old_y]
  end

  def to_s
    @col == "white" ? @white_rook : @black_rook
  end
end
