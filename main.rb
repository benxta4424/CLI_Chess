require "./lib/board"
require "./lib/rook"
require "./lib/knight"
require "./lib/bishop"
require "./lib/queen"
require "./lib/pawn"
require "./lib/king"

board = Board.new
board.draw_board
board.add_pieces(Rook, "black", 0, 0)
board.add_pieces(Rook, "black", 0, 7)

board.add_pieces(Rook, "white", 7, 0)
board.add_pieces(Rook, "white", 7, 7)

board.add_pieces(Knight, "white", 7, 1)
board.add_pieces(Knight, "white", 7, 6)

board.add_pieces(Knight, "black", 0, 1)
board.add_pieces(Knight, "black", 0, 6)

board.add_pieces(Bishop, "black", 0, 5)
board.add_pieces(Bishop, "black", 0, 2)

board.add_pieces(Bishop, "white", 7, 5)
board.add_pieces(Bishop, "white", 7, 2)

board.add_pieces(Queen, "white", 7, 3)
board.add_pieces(Queen, "black", 0, 3)

board.add_pieces(King, "white", 7, 4)
board.add_pieces(King, "black", 0, 4)

0.upto(7) do |counter|
  board.add_pieces(Pawn, "black", 1, counter)
end

0.upto(7) do |counter|
  board.add_pieces(Pawn, "white", 6, counter)
end

board.play_game
