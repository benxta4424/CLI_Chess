class Piece
  attr_accessor :color, :symbol

  def initialize(col)
    @color = col
    @symbol = set_symbol
  end

  def check_color
    @color == "white" ? @symbol : @symbol
  end

  def move_front(board, old_position, new_position)
    old_x = old_position[0]
    old_y = old_position[1]

    new_x = new_position[0]
    new_y = new_position[1]

    board[new_x][new_y] = board[old_x][old_y]
  end
end
