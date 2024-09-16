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

  def possible_moves(pieces, current_x, current_y)

    @possible_and_legal_positions.clear
    
    starting_piece = pieces[current_x][current_y]

    get_possible_moves(pieces,current_x,current_y,1,1,starting_piece)  
    get_possible_moves(pieces,current_x,current_y,1,-1,starting_piece) 
    get_possible_moves(pieces,current_x,current_y,-1,1,starting_piece) 
    get_possible_moves(pieces,current_x,current_y,-1,-1,starting_piece) 

    @possible_and_legal_positions

  end
end
