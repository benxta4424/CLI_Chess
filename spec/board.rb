require "./lib/board"
require "./lib/piece"
require "./lib/players"
require "./lib/board"
require "./lib/rook"
require "./lib/knight"
require "./lib/bishop"
require "./lib/queen"
require "./lib/pawn"
require "./lib/king"

describe Board do
  describe "#is_even?" do
    let(:mother_class) { described_class.new }
    let(:even_sum) { [0, 2] }
    let(:uneven_sum) { [1, 6] }

    it "returns true for an even sum of indexes" do
      solution = mother_class.is_even?(even_sum[0], even_sum[1])
      expect(solution).to eq(true)
    end

    it "returns false for a uneven sum of indexes" do
      solution = mother_class.is_even?(uneven_sum[0], uneven_sum[1])
      expect(solution).to eq(false)
    end
  end

  describe "#color_piece" do
    let(:mother_class) { described_class.new }
    let(:even_sum) { [0, 2] }
    let(:uneven_sum) { [1, 6] }

    before do
      allow(mother_class).to receive(:first_color).and_return(:light_white)
      allow(mother_class).to receive(:second_color).and_return(:green)
    end

    it "returns light-white for an even sum" do
      solution = mother_class.color_piece(even_sum[0], even_sum[1])
      expect(solution).to eq(:light_white)
    end

    it "returns green for an uneven sum" do
      solution = mother_class.color_piece(uneven_sum[0], uneven_sum[1])
      expect(solution).to eq(:green)
    end
  end

  describe "#is_legal?" do
    let(:mother_class) { described_class.new }
    context "the legal limit is within the 0-7 bounds for indexes" do
      let(:in_bounds) { [0, 1] }
      let(:out_of_bounds) { [0, 8] }

      it "returns true for indexes within bounds" do
        solution = mother_class.is_legal?(in_bounds[0], in_bounds[1])
        expect(solution).to eq(true)
      end

      it "returns false for indexes out of bounds" do
        solution = mother_class.is_legal?(out_of_bounds[0], out_of_bounds[1])
        expect(solution).to eq(false)
      end
    end
  end

  describe "#add_pieces" do
    let(:new_board) { described_class.new }

    context "adding pieces on the board" do
      let(:queen_class) { Queen }
      let(:piece_color) { "white" }
      let(:x_and_y) { [0, 3] }

      it "should put the queen at given positions" do
        new_board.add_pieces(queen_class, piece_color, x_and_y[0], x_and_y[1])

        piece = new_board.pieces[x_and_y[0]][x_and_y[1]]

        expect(piece).to be_a(Queen)
        expect(piece.color).to eq(piece_color)
      end
        
        it "should put the rooks at given positions" do
        new_board.add_pieces(Rook, piece_color,0, 0)

        piece = new_board.pieces[0][0]

        expect(piece).to be_a(Rook)
        expect(piece.color).to eq(piece_color)
      end
    end

    context "checking added pieces's color" do

      let(:piece_class) { Bishop }
      let(:piece_color) { "black" }
      let(:x_and_y) { [0, 2] }

      it "correctly returns the pieces's color" do
      new_board.add_pieces(piece_class,piece_color,0,2)

      piece=new_board.pieces[0][2]

      expect(piece.color).to eq("black")
      end
    end

    context "in case of out of bounds moves" do
      let(:queen_class) { Queen }
      let(:piece_color) { "white" }
      let(:x_and_y) { [0, 9] }

      it "should return nil for out of bounds moves" do
        new_board.add_pieces(queen_class, piece_color, x_and_y[0], x_and_y[1])

        piece = new_board.pieces[x_and_y[0]][x_and_y[1]]

        expect(piece).to eq(nil)
      end
    end
  end

  describe "#move_pieces" do
    let(:new_board) { described_class.new }
    let(:current_piece_location){[0,1]}

    context "moving the piece to a custom location" do
      let(:move_location){[2,1]}

      it "moves the piece from 0-1 to 2-1" do
        new_board.add_pieces(King,"white",0,1)
        new_board.move_pieces([0,1],[2,1])
        piece=new_board.pieces[2][1]

        expect(piece).to be_a(King)
      end

      it "moves the piece from 7-7 to 7-0" do
        new_board.add_pieces(Rook,"white",7,7)
        new_board.move_pieces([7,7],[7,0])
        piece=new_board.pieces[7][0]
        
        expect(piece).to be_a(Rook)
        expect(piece.color).to eq("white")
      end
    end

    context "if the pieces are kings,we memorize their location" do

      it "should memorize [6,4] for the white king that's currently at [7,4]" do
        new_board.add_pieces(King,"white",7,4)
        new_board.move_pieces([7,4],[6,4])
        current_white_king_position=new_board.instance_variable_get(:@white_king_position)

        x_pos,y_pos=current_white_king_position
        piece=new_board.pieces[x_pos][y_pos]

        expect(piece).to be_a(King)
        expect(piece.color).to eq("white")

      end

      it "should memorize [1,3] for the white king that's currently at [0,3]" do
        new_board.add_pieces(King,"black",0,3)
        new_board.move_pieces([0,3],[1,3])
        current_black_king_position=new_board.instance_variable_get(:@black_king_position)

        x_pos,y_pos=current_black_king_position
        piece=new_board.pieces[x_pos][y_pos]

        expect(piece).to be_a(King)
        expect(piece.color).to eq("black")

      end

      context "checking for the previous position after movement" do

        it "[0,1]-current position should be NIL after movement to [2,0]-next position" do
          new_board.add_pieces(Knight,"black",0,1)
          new_board.move_pieces([0,1],[2,0])
          nil_piece=new_board.pieces[0][1]

          expect(nil_piece).to eq(nil)
        end
      end

      context "if a piece is captured on a square,we memorize its color and symbol" do

        it "returns a Queen for a captured piece" do
          new_board.add_pieces(Bishop,"black",0,2)
          new_board.add_pieces(Queen,"white",0,3)
          new_board.move_pieces([0,2],[0,3])

          captured_piece=new_board.instance_variable_get(:@captured_piece_symbol).join

          expect(captured_piece).to eq(" \u2655 ")
        end

        it "returns the Queens color for a captured piece" do
          new_board.add_pieces(Bishop,"black",0,2)
          new_board.add_pieces(Queen,"white",0,3)
          new_board.move_pieces([0,2],[0,3])

          captured_piece=new_board.instance_variable_get(:@captured_piece_color).join

          expect(captured_piece).to eq("white")
        end
      end
    end

  end

  describe "#piece_possible_moves" do
    let(:board) { described_class.new }

    context "checks a piece's possible movements" do

      let(:knight){[2,0]}

      it "for a knight located at [0,1] the possible moves are:[2,0],[2,2]" do
        board.add_pieces(Knight,"black",0,1)
        possible_mvs=board.piece_possible_moves(0,1)

        expect(possible_mvs).to include(knight)
      end

      it "for a king surrounded by pieces there are no possible moves" do
        board.add_pieces(King,"black",0,0)
        board.add_pieces(Knight,"black",0,1)
        board.add_pieces(Knight,"black",1,0)
        board.add_pieces(Knight,"black",1,1)

        possible_mvs=board.piece_possible_moves(0,0)
        
        expect(possible_mvs).to eq(Array.new)
      end
    end
  end

  describe "#king_in_check?" do
  
  let(:board){described_class.new}

    context "the king is in check by a Queen" do

      it "a white king at [7,1] is threatened by a black Queen at [2,1]" do
        board.add_pieces(King,"white",7,4)
        board.add_pieces(Queen,"black",0,4)
        expect(board.king_in_check?("white")).to eq(true)
      end

      it "a white king at [7,4] is threatened by a black Knight at [6,6]" do
        board.add_pieces(King,"white",7,4)
        board.add_pieces(Knight,"black",6,6)
        expect(board.king_in_check?("white")).to eq(true)
      end

      it "a white king at [7,4] is threatened by a black Rook at [6,4]" do
        board.add_pieces(King,"white",7,4)
        board.add_pieces(Rook,"black",6,4)
        expect(board.king_in_check?("white")).to eq(true)
      end

      it "a white king at [7,4] is threatened by a black Bishop at [5,2]" do
        board.add_pieces(King,"white",7,4)
        board.add_pieces(Bishop,"black",5,2)
        expect(board.king_in_check?("white")).to eq(true)
      end

      context "the king is in a safe position" do
        it "a white king at [7,4] is safe from a black Bishop at [5,3]" do
          board.add_pieces(King,"white",7,4)
          board.add_pieces(Bishop,"black",5,3)
          expect(board.king_in_check?("white")).to eq(false)
        end

        it "a white king at [7,4] is safe from a black Queen at [2,3]" do
          board.add_pieces(King,"white",7,4)
          board.add_pieces(Queen,"black",2,3)
          expect(board.king_in_check?("white")).to eq(false)
        end
  
        it "a white king at [7,4] is safe from a black Knight at [7,6]" do
          board.add_pieces(King,"white",7,4)
          board.add_pieces(Knight,"black",7,6)
          expect(board.king_in_check?("white")).to eq(false)
        end
  
        it "a white king at [7,4] is safe from a black Rook at [6,5]" do
          board.add_pieces(King,"white",7,4)
          board.add_pieces(Rook,"black",6,5)
          expect(board.king_in_check?("white")).to eq(false)
        end
      end
    end

    describe "check_mate?" do

      let(:board){described_class.new}
      
      context "if the king is not even in check,it can't be a checkmate" do

        it "returns false when a king is not in check" do
          board.add_pieces(King,"white",7,4)
          board.add_pieces(Rook,"black",6,5)

          expect(board.check_mate?("white")).to eq(false)
        end
      end

      context "the king being attacked by two pieces with no way to escape is checkmate" do

        it "returns checkmate for a trapped king" do
          board.add_pieces(King,"white",7,4)
          board.add_pieces(Rook,"black",7,0)
          board.add_pieces(Rook,"black",7,7)
          board.add_pieces(Queen,"black",6,0)

          expect(board.check_mate?("white")).to eq(true)
        end
      end

      context "if the king can escape there is not a checkmate" do

        it "returns false for a king with a possible escape" do
          board.add_pieces(King,"white",7,4)
          board.add_pieces(Rook,"black",7,0)
          
          expect(board.check_mate?("white")).to eq(false)
        end
      end
    end
  end

  describe "#stalemate?" do
    let(:board){described_class.new}

    context "checking for check" do

      it "returns false for a king that's in check" do
        board.add_pieces(King,"white",7,4)
        board.add_pieces(Rook,"black",7,0)
        check_stalemate=board.stalemate?("white")

        expect(check_stalemate).to eq(false)
      end
    end

    context "when the stalemate scenario is true" do
      it "returns true for a scenario like:w_king[6,6],b_king[4,5],b_queen[0,0],w_pawn[1,1]" do
        board.add_pieces(King,"white",6,6)
        board.add_pieces(King,"black",4,5)
        board.add_pieces(Queen,"black",0,0)
        board.add_pieces(Pawn,"white",1,1)
        stalemate_check=board.stalemate?("white")

        expect(stalemate_check).to eq(true)
      end

      it "stalemate for black:w_king[5,5],b_king[6,6],w_pawn[6,4],w_queen[4,4]" do
        board.add_pieces(King,"white",5,5)
        board.add_pieces(King,"black",6,6)
        board.add_pieces(Queen,"white",4,4)
        board.add_pieces(Pawn,"white",6,4)
        stalemate_check=board.stalemate?("white")

        expect(stalemate_check).to eq(true)
      end
    end
  end

  describe "#safe_positions_for_the_king" do
    let(:board){described_class.new}
    let(:expected_output_test1){[[6,4],[6,5],[6,3]]}
    let(:expected_output_test2){[[6,5],[6,3]]}

    context "testing for safe spots" do
      it "white king at his normal pos surrounded by:queen[7,0]. escape routes:[6,3],[6,4],[6,5]" do
        board.add_pieces(King,"white",7,4)
        board.add_pieces(Queen,"black",7,0)
        positions=board.safe_positions_for_the_king("white")

        expect(positions).to eq(expected_output_test1)
      end

      it "white king at his normal pos surrounded by:queen[7,0],rook[1,4]. escape routes:[6,3],[6,5]" do
        board.add_pieces(King,"white",7,4)
        board.add_pieces(Queen,"black",7,0)
        board.add_pieces(Rook,"black",1,4)

        positions=board.safe_positions_for_the_king("white")

        expect(positions).to eq(expected_output_test2)
      end
    end

    context "no escape route for the king" do
      it "returns an empty array for no possible escapes" do
        board.add_pieces(King,"white",7,4)
        board.add_pieces(Rook,"black",7,0)
        board.add_pieces(Rook,"black",6,0)
        
        positions=board.safe_positions_for_the_king("white")

        expect(positions).to eq(Array.new)
      end
    end
  end
end
