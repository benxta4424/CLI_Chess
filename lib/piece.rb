class Piece
  attr_accessor :color, :symbol

  def initialize(col)
    @color = col
    @symbol = set_symbol
    @possible_and_legal_positions=[]
  end

  def check_color
    @color == "white" ? @symbol : @symbol
  end

  def is_legal?(x,y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def move_front(board, old_position, new_position)
    old_x = old_position[0]
    old_y = old_position[1]

    new_x = new_position[0]
    new_y = new_position[1]

    board[new_x][new_y] = board[old_x][old_y]
  end

  def get_possible_moves(pieces,current_x,current_y,x_case,y_case,starting_piece)
    starting_piece=pieces[current_x][current_y]

    x_axis=current_x+x_case
    y_axis=current_y+y_case

    while is_legal?(x_axis,y_axis)
        current_piece=pieces[x_axis][y_axis]

        if !current_piece.nil?
            
            if current_piece.color==starting_piece.color && x_axis!=current_x && y_axis!=current_y
                @possible_and_legal_positions<<[x_axis-x_case,y_axis-y_case]
                break
            elsif current_piece.color!=starting_piece.color
                @possible_and_legal_positions<<[x_axis,y_axis]
                break
            end

        elsif x_axis==7 || x_axis==0 || y_axis==7 || y_axis==0
            @possible_and_legal_positions<<[x_axis,y_axis]
            break
        end

        x_axis+=x_case
        y_axis+=y_case
    end

    @possible_and_legal_positions
  end
end
