require 'colorize'
require './lib/rook'

class Board
    attr_accessor :board, :first_color, :second_color

    def initialize
        @board=Array.new(8){Array.new(8)}
        @first_color=:light_white
        @second_color=:green
        @pieces=Array.new(8){Array.new(8)}
    end


    def draw_board
        board.each_with_index do |row,row_ind|
            row.each_with_index do |col,col_ind|
                if is_even?(row_ind,col_ind)
                    row[col_ind]="   ".colorize(background: first_color)
                else
                    row[col_ind]="   ".colorize(background: second_color)
                end
            end
        end
    end

    def print_board
        board.each {|row| puts row.join}
    end


    def pieces
        @pieces.each do |items|
            puts items.join
        end
    end

    def is_even?(ind_one,ind_two)
        (ind_one+ind_two).even?
    end

    def color_piece(ind_one,ind_two)
        is_even?(ind_one,ind_two) ? first_color : second_color
    end

    def is_legal?(ind_one,ind_two)

        if ind_one.between?(0,7) && ind_two.between?(0,7)
            return true
        elsif !ind_one.between?(0,7) || !ind_two.between?(0,7)
            return false
        else
            raise ArgumentError
     
        end

    end

end