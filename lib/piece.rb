class Piece
  attr_accessor :color, :symbol

  def initialize(col)
    @color = col
    @symbol = set_symbol
  end

  def check_color
    @color = "white" ? @symbol : @symbol
  end
end
