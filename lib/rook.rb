require 'colorize'

class Rook

    ROOK_MOVEMENTS=[[0,1],[0,-1],[1,0],[-1,0]]

    attr_accessor :color,:symbol

    def initialize(color)
        @col=color
        @white_rook=" \u2656 "
        @black_rook=" \u265C "
        @symbol=color=='white' ? @white_rook : @black_rook
    end

    def check_color
        if @col == 'white'
            @white_rook
        elsif @col == 'black'
            @black_rook
        end
    end

    def colorize_rook(piece,color)
        piece.colorize(background: color)
    end

    def move_front(board,old_position,new_position)
        old_x=old_position[0]
        old_y=old_position[1]

        new_x=new_position[0]
        new_y=new_position[1]

        board[new_x][new_y]=board[old_x][old_y]
    end

    def to_s
        @col=='white' ? @white_rook : @black_rook
    end
end