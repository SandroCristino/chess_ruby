require_relative 'piece'

class Board
  attr_reader :board

  # Initialize the board 8x8
  def initialize(board = nil)
    if board
      @board = board
    else
      @board = Array.new(8) { Array.new(8, nil) }
      setup_initialze(@board)
    end
  end

  def setup_initialze(grid)
    # Initialize white
    grid[0][0] = Rook.new(:black, [0, 0])
    grid[0][1] = Knight.new(:black, [0, 1])
    grid[0][2] = Bishop.new(:black, [0, 2])
    grid[0][3] = Queen.new(:black, [0, 3])
    grid[0][4] = King.new(:black, [0, 4])
    grid[0][5] = Bishop.new(:black, [0, 5])
    grid[0][6] = Knight.new(:black, [0, 6])
    grid[0][7] = Rook.new(:black, [0, 7])
    grid[1].map! { |n| Pawn.new(:black, [1, n]) }

    # Initialize black
    grid[7][0] = Rook.new(:white, [7, 0])
    grid[7][1] = Knight.new(:white, [7, 1])
    grid[7][2] = Bishop.new(:white, [7, 2])
    grid[7][3] = Queen.new(:white, [7, 3])
    grid[7][4] = King.new(:white, [7, 4])
    grid[7][5] = Bishop.new(:white, [7, 5])
    grid[7][6] = Knight.new(:white, [7, 6])
    grid[7][7] = Rook.new(:white, [7, 7])
    grid[6].map! { |n| Pawn.new(:white, [6, n]) }
  end

  def display
    puts '  a   b   c   d   e   f   g   h '
    puts '  ---------------------------------'

    @board.each_with_index do |row, index|
      print "#{index} |"
      row.each do |square|
        if square.nil?
          print '   |'
        else
          print " #{square.symbol} |"
        end
      end
      puts "\n  ---------------------------------"
    end
  end

  def make_move(current_position, target_position)
    current_row, current_col = current_position
    target_row, target_col = target_position

    # Check valid move
    valid_move_result = valid_move(current_position, target_position)

    # if @board[target_row][target_col].nil? || @board[target_row][target_col].color != piece.color
    if valid_move_result

      # Get piece
      piece = @board[current_row][current_col]

      # Move piece
      @board[target_row][target_col] = piece
      @board[current_row][current_col] = nil

      # Update piece position
      piece.update_position([target_row, target_col])
      true
    end

    false
  end

  def valid_move(current_position, target_position)
    current_row, current_col = current_position
    target_row, target_col = target_position

    # Get piece
    piece = @board[current_row][current_col]

    # Check if square is not empty, move is valid
    return false if piece.nil? || !piece.valid_moves(current_position, target_position)

    # Check if target position is own player
    return false if @board[target_row][target_col] && (@board[target_row][target_col].color == piece.color)

    # Check if next move result in checkmate
    return false if next_move_checkmate?(current_position, target_position)

    # Check square between current and target position
    row_difference = current_row - target_row
    col_difference = current_col - target_col
    distance = [row_difference.abs, col_difference.abs].max

    # Iterate over each square between current and target position
    (1...distance).each do |step|
      # Skip if piece is kinght
      next if piece.is_a?(Knight)

      row = current_row - (row_difference * step / distance)
      col = current_col - (col_difference * step / distance)
      return false unless @board[row][col].nil?
    end

    true
  end

  def check_attack(target_position)
    target_row, target_col = target_position

    if @board[target_row][target_col]
      true
    else
      false
    end
  end

  def check?(color, _board = @board)
    # Find the king
    king = find_king(color)

    # Get opponent pieces
    opponent_color = color == :white ? :black : :white
    opponent_pieces = find_pieces(opponent_color)

    # Check opponent pieces moves
    opponent_pieces.each do |piece|
      return true if piece.valid_moves(piece.position, king.position)
    end

    false
  end

  def checkmate?(color)
    # Find king
    king = find_king(color)
    king_position = king.position

    # Check if the king is in check
    return false unless check?(color)

    # Iterate through all possible moves for the king
    king_row, king_col = king_position

    # Iterate 3x3 grid
    (-1..1).each do |row_offset|
      (-1..1).each do |col_offset|
        # Skip if king position
        next if row_offset == 0 && col_offset == 0

        target_row = king_row + row_offset
        target_col = king_col + col_offset

        # Check if the move is valid
        next unless valid_move(king_position, [target_row, target_col])

        # Check if doesn't put the king in check
        temp_board = Board.new(@board)
        temp_board.make_move(king_position, [target_row, target_col])
        return false unless temp_board.check?(color)
      end
    end

    true
  end

  def stalemate?(color)
    # Return if check is true
    return false if check?(color)

    # Find king location
    king = find_king(color)
    king_position = king.position

    # Iterate through all possible moves for the king
    king_row, king_col = king_position

    # Iterate 3x3 grid
    (-1..1).each do |row_offset|
      (-1..1).each do |col_offset|
        # Skip if king position
        next if row_offset == 0 && col_offset == 0

        target_row = king_row + row_offset
        target_col = king_col + col_offset

        # Skip if negative coordinates
        next if target_row < 0 || target_col < 0 || target_row > 7 || target_col > 7

        # Check if move is valid
        next unless valid_move(king_position, [target_row, target_col])

        # Check if doesn't put the king in check
        temp_board = Board.new(@board)
        temp_board.make_move(king_position, [target_row, target_col])
        return true if temp_board.check?(color) == true
      end
    end

    false
  end

  # Simplified draw
  def draw?
    # Get pieces from white and black
    white_pieces = @board.flatten.select { |piece| piece&.color == :white }
    black_pieces = @board.flatten.select { |piece| piece&.color == :black }

    # Definde sufficient pieces
    sufficient_pieces = [Queen, Pawn, Rook]

    # Check if each side has at least one of them
    return true if  white_pieces.none? { |piece| sufficient_pieces.include?(piece.class) } &&
                    black_pieces.none? { |piece| sufficient_pieces.include?(piece.class) }

    false
  end

  def check_promotion(target_position)
    target_row, target_col = target_position
    pawn = @board[target_row][target_col]
    if pawn.is_a?(Pawn) && [0, 7].include?(target_row)
      true
    else
      false
    end
  end

  def run_promotion(target_position)
    target_row, target_col = target_position
    pawn = @board[target_row][target_col]
    color = pawn.color

    # Get new piece
    input = ''
    pieces = %w[rook knight bishop queen]

    while true
      puts 'Type your piece: rook, knight, bishop, queen'
      input = gets.chomp.downcase
      break if pieces.include?(input)
    end

    case input
    when 'rook'
      new_piece = Rook
    when 'knight'
      new_piece = Knight
    when 'bishop'
      new_piece = Bishop
    when 'queen'
      new_piece = Queen
    end

    @board[target_row][target_col] = new_piece.new(color, [target_row, target_col])
  end

  def castle_kingside(color)
    king = find_king(color)
    return false if king.first_move || check?(color) || !clear_path_kingside?(color)

    # Check if current and target poistion is proper castle position

    if color == :white

      # King switch
      @board[7][6] = @board[7][4]
      @board[7][4] = nil

      # Rook switch
      @board[7][5] = @board[7][7]
      @board[7][7] = nil
    else

      # King switch
      @board[0][6] = @board[0][4]
      @board[0][4] = nil

      # Rook switch
      @board[0][5] = @board[0][7]
      @board[0][7] = nil
    end
  end

  def castle_queenside(color)
    king = find_king(color)
    return false if king.first_move || check?(color) || !clear_path_queenside?(color)

    if color == :white

      # King switch
      @board[7][2] = @board[7][4]
      @board[7][4] = nil

      # Rook switch
      @board[7][3] = @board[7][0]
      @board[7][0] = nil
    else

      # King switch
      @board[0][2] = @board[0][4]
      @board[0][4] = nil

      # Rook switch
      @board[0][3] = @board[0][0]
      @board[0][0] = nil
    end
  end

  def pawn_attack(current_position, target_position)
    current_row, current_col = current_position
    target_row, target_col = target_position

    # Get color/ piece
    piece = @board[current_row][current_col]
    color = piece.color
    opponent_color = @board[target_row][target_col].color

    # Pawn is allowed just moving forward
    moving_forward = (current_row < target_row && color == :black) || (current_row > target_row && color == :white)

    return false unless piece.valid_moves(current_position, target_position)
    return true if opponent_color != color && moving_forward && piece.is_a?(Pawn)

    false
  end

  def check_position_kingside(current_position, target_position)
    # Get position
    current_row, current_col = current_position
    target_row, target_col = target_position

    # Get piece
    piece = @board[current_row][current_col]

    return false unless piece.is_a?(King) || piece.is_a?(Rook)
    if [0,
        7].include?(current_row) && [4,
                                     7].include?(current_col) && [0,
                                                                  7].include?(target_row) && [6, 5].include?(target_col)
      return true
    end

    false
  end

  def check_position_queenside(current_position, target_position)
    # Get position
    current_row, current_col = current_position
    target_row, target_col = target_position

    # Get piece
    piece = @board[current_row][current_col]

    return false unless piece.is_a?(King) || piece.is_a?(Rook)
    if [0,
        7].include?(current_row) && [4,
                                     7].include?(current_col) && [0,
                                                                  7].include?(target_row) && [2, 3].include?(target_col)
      return true
    end

    false
  end

  private

  def next_move_checkmate?(current_position, target_position)
    # Get position
    current_row, current_col = current_position
    target_row, target_col = target_position

    #  Create instance
    temp_board = Board.new(@board)

    piece = temp_board.board[current_row][current_col]
    return false if piece.nil?

    # Get color
    color = piece.color

    # Simulate move
    temp_board.board[target_row][target_col] = piece
    temp_board.board[current_row][current_col] = nil
    piece.update_position([target_row, target_col])

    # Check if checkmate
    temp_board.check?(color)
  end

  def clear_path_kingside?(color)
    # Check for any pieces between the king and kingside rook
    row = color == :white ? 7 : 0
    (5..6).none? { |col| @board[row][col] }
  end

  def clear_path_queenside?(color)
    # Check for any pieces between the king and queenside rook
    row = color == :white ? 7 : 0
    (1..3).none? { |col| @board[row][col] }
  end

  def find_king(color)
    @board.flatten.find { |piece| piece.is_a?(King) && piece.color == color }
  end

  def find_pieces(color)
    @board.flatten.select do |piece|
      !piece.nil? && piece.color == color
    end
  end
end

# Create board
board_template = Array.new(8) { Array.new(8, nil) }
board_template[2][3] = Queen.new(:white, [2, 3])
board_template[4][4] = Queen.new(:white, [4, 4])
board_template[1][0] = King.new(:black, [1, 0])

# Create instance
board = Board.new(board_template)

p board.stalemate?(:black)
