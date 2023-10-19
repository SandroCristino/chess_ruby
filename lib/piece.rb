class Piece
  attr_reader :color, :symbol, :position
  attr_accessor :position

  def initialize(color)
    @color = color      # Either white or black
    @symbol = color == :white ? '♔' : '♚'
    @position = [nil, nil]
  end

  def update_position(position)
    @position = position
  end
end

class King < Piece
  attr_reader :first_move

  def initialize(color, position)
    @color = color
    @symbol = color == :white ? '♔' : '♚'
    @position = position  
    @first_move = false
  end

  def valid_moves(current_position, target_position)
    # Extract current position coordinates
    current_row, current_col = current_position
    target_row, target_col = target_position

    # Calculate the absolute row and column differences
    row_difference = (current_row - target_row).abs
    col_difference = (current_col - target_col).abs

    # A King can move one square in any direction
    if (row_difference <= 1) && (col_difference <= 1) 
      @first_move = true
      return true
    end

    false
  end
end

class Queen < Piece
  def initialize(color, position)
    @color = color
    @symbol = color == :white ? '♕' : '♛'
    @position = position
  end

  def valid_moves(current_position, target_position)
    horizontal = current_position[1] == target_position[1]
    vertical = current_position[0] == target_position[0]
    diagonal = (current_position[0] - target_position[0]).abs == (current_position[1] - target_position[1]).abs

    return true if horizontal || vertical || diagonal

    false
  end
end

class Rook < Piece
  def initialize(color, position)
    super(color)
    @symbol = color == :white ? '♖' : '♜'
    @position = position
  end

  def valid_moves(current_position, target_position)
    horizontal = current_position[1] == target_position[1]
    vertical = current_position[0] == target_position[0]

    return true if horizontal || vertical

    false
  end
end

class Bishop < Piece
  def initialize(color, position)
    super(color)
    @symbol = color == :white ? '♗' : '♝'
    @position = position
  end

  def valid_moves(current_position, target_position)
    diagonal = (current_position[0] - target_position[0]).abs == (current_position[1] - target_position[1]).abs

    return true if diagonal

    false
  end
end

class Knight < Piece
  def initialize(color, position)
    super(color)
    @symbol = color == :white ? '♘' : '♞'
    @position = position
  end

  def valid_moves(current_position, target_position)
    row_difference = (current_position[0] - target_position[0]).abs
    col_difference = (current_position[1] - target_position[1]).abs

    return true if (row_difference == 2 && col_difference == 1) || (col_difference == 2 && row_difference == 1)

    false
  end
end

class Pawn < Piece
  def initialize(color, position)
    super(color)
    @symbol = color == :white ? '♙' : '♟'
    @position = position
  end

  def valid_moves(current_position, target_position)
    # Two steps move
    two_steps_move = current_position[0] == 1 || current_position[0] == 6

    # Black is above
    black_legal_move = color == :black && current_position[0] + 1 == target_position[0]
    white_legal_move = color == :white && current_position[0] - 1 == target_position[0]

    # One step move
    one_step_move = black_legal_move || white_legal_move

    return true if one_step_move || two_steps_move

    false
  end
end

king = King.new(:black, [0, 4])
puts king.valid_moves([0,4], [0,5])
puts king.first_move
