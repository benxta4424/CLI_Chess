require "./lib/piece"

class Pawn < Piece
    attr_accessor :color,:symbol

    def set_symbol
        self.color=="white" ? " \u2659 " : " \u265F "
    end
end