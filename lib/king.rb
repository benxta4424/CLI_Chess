require "./lib/piece"

class King < Piece
  attr_accessor :color, :symbol

  def set_symbol
    color == "white" ? " \u2654 " : " \u265A "
  end
end
