require "./lib/board"
require "./lib/rook"
require "./lib/knight"
require "./lib/bishop"
require "./lib/queen"
require "./lib/pawn"
require "./lib/king"

board = Board.new
board.draw_board


board.add_pieces(King, "white", 7, 4)
board.add_pieces(Queen,"black",7,0)
puts board.safe_positions_for_the_king("white")
