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

  end
end
