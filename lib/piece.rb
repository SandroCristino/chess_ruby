class Piece
  attr_reader :color, :symbol

  def initialize(color)
    @color = color      # Either white or black
    @symbol = color == :white ? '♔' : '♚'
  end

  
end

class King < Piece
  def initialize(color)
    @color = color
    @symbol = color == :white ? '♔' : '♚'
  end

  def valid_moves(current_position, target_position)
    row_difference = (current_position[0] - target_position[0]).abs
    col_dfference = (current_position[1] - current_position[1]).abs

    # King can move 1 in any direction
    return true if row_difference <= 1 && col_dfference <= 1

    false

    # NOTE: Casteling defined in Board
  end
end

class Queen < Piece
  def initialize(color)
    @color = color
    @symbol = color == :white ? '♕' : '♛'
  end

  def valid_moves(current_position, target_position)
    horizontal = current_position[1] == target_position[1]
    vertical = current_position[0] == target_position[0]
    diagonal = (current_position[0] - current_position[1]) == (target_position[0] - target_position[1])

    return true if horizontal || vertical || diagonal

    false
  end
end

class Rook < Piece
  def initialize(color)
    super(color)
    @symbol = color == :white ? '♖' : '♜'
  end

  def valid_moves(current_position, target_position)
    horizontal = current_position[1] == target_position[1]
    vertical = current_position[0] == target_position[0]

    return true if horizontal || vertical

    false
  end
end

class Bishop < Piece
  def initialize(color)
    super(color)
    @symbol = color == :white ? '♗' : '♝'
  end

  def valid_moves(current_position, target_position)
    diagonal = (current_position[0] - target_position[0]).abs == (current_position[1] - target_position[1]).abs

    return true if diagonal

    false
  end
end

class Knight < Piece
  def initialize(color)
    super(color)
    @symbol = color == :white ? '♘' : '♞'
  end

  def valid_moves(current_position, target_position)
    row_difference = (current_position[0] - target_position[0]).abs
    col_difference = (current_position[1] - target_position[1]).abs

    return true if (row_difference == 2 && col_difference == 1) || (col_difference == 2 && row_difference == 1)

    false
  end
end

class Pawn < Piece
  def initialize(color)
    super(color)
    @symbol = color == :white ? '♙' : '♟'
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
