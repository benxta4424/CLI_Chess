require 'colorize'

class Board
    attr_accessor :board, :first_color, :second_color

    def initialize
        @board=Array.new(7){Array.new(7)}
        @first_color=:light_white
        @second_color=:green
    end

    def is_even?(ind_one,ind_two)
        (ind_one+ind_two).even?
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
end