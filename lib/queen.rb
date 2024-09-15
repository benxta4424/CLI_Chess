require "./lib/piece"

class Queen < Piece
    attr_accessor :color,:symbol

    def set_symbol
        self.color == "white" ? " \u2655 " : " \u265B "
    end
end