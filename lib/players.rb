class Players
  attr_accessor :name, :color_choice, :captured_pieces

  def initialize(nam, col)
    @name = nam
    @color_choice = col
    @captured_pieces = []
  end
end
