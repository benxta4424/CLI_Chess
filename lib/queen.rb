require "./lib/piece"

class Queen < Piece
    attr_accessor :color,:symbol

    def set_symbol
        self.color == "white" ? " \u2655 " : " \u265B "
    end


    def possible_moves(pieces,current_x,current_y)
        @possible_and_legal_positions.clear

        current_piece=pieces[current_x][current_y]

        get_possible_moves(pieces,current_x,current_y,0,1,current_piece)
        get_possible_moves(pieces,current_x,current_y,0,-1,current_piece)
        get_possible_moves(pieces,current_x,current_y,1,0,current_piece)
        get_possible_moves(pieces,current_x,current_y,-1,0,current_piece)
        get_possible_moves(pieces,current_x,current_y,1,1,current_piece)
        get_possible_moves(pieces,current_x,current_y,-1,1,current_piece)
        get_possible_moves(pieces,current_x,current_y,1,-1,current_piece)
        get_possible_moves(pieces,current_x,current_y,-1,-1,current_piece)
        @possible_and_legal_positions
    end
end