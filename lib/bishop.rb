require "./lib/piece"
require "./lib/board"


class Bishop < Piece
    attr_accessor :color,:symbol

    def set_symbol
        self.color == "white" ? " \u2657 " : " \u265D "
    end
end