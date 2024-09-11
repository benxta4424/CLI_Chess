require './lib/piece'

class Knight < Piece
    attr_accessor :color,:symbol

    def set_symbol
        @color=="white" ? " \u2658 " : " \u265E "
    end
end