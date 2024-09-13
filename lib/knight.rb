require "./lib/piece"
require "./lib/board"

class Knight < Piece
    attr_accessor :color,:symbol

    def set_symbol
        self.color == "white" ?  " \u2658 " : " \u265E "
    end
end