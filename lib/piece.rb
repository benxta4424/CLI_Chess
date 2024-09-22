class Piece
  attr_accessor :color, :symbol

  def initialize(col)
    @color = col
    @symbol = set_symbol
    @possible_and_legal_positions = []
    @possible_new_piece = []
  end

  def check_color
    @color == "white" ? @symbol : @symbol
  end

  def is_legal?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def move_front(board, old_position, new_position)
    old_x = old_position[0]
    old_y = old_position[1]

    new_x = new_position[0]
    new_y = new_position[1]

    board[new_x][new_y] = board[old_x][old_y]
  end

  def get_possible_moves(pieces, current_x, current_y, x_case, y_case, starting_piece)
    x_axis = current_x + x_case
    y_axis = current_y + y_case

    while is_legal?(x_axis, y_axis)
      current_piece = pieces[x_axis][y_axis]

      if current_piece.nil?
        @possible_and_legal_positions << [x_axis, y_axis]
      elsif current_piece.color == starting_piece.color

        # if its a friendly piece stop before it
        break

        # if its an enemy piece you can capture it an take its place
      elsif current_piece.color != starting_piece.color
        @possible_and_legal_positions << [x_axis, y_axis]
        break

        # if its an empty square we progress forward
      end

      x_axis += x_case
      y_axis += y_case
    end

    @possible_and_legal_positions
  end
end
