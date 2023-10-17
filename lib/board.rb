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
    grid[0][0] = Rook.new(:black)
    grid[0][1] = Knight.new(:black)
    grid[0][2] = Bishop.new(:black)
    grid[0][3] = Queen.new(:black)
    grid[0][4] = King.new(:black)
    grid[0][5] = Bishop.new(:black)
    grid[0][6] = Knight.new(:black)
    grid[0][7] = Rook.new(:black)
    grid[1].map! { |_n| Pawn.new(:black) }

    # Initialize black
    grid[7][0] = Rook.new(:white)
    grid[7][1] = Knight.new(:white)
    grid[7][2] = Bishop.new(:white)
    grid[7][3] = Queen.new(:white)
    grid[7][4] = King.new(:white)
    grid[7][5] = Bishop.new(:white)
    grid[7][6] = Knight.new(:white)
    grid[7][7] = Rook.new(:white)
    grid[6].map! { |_n| Pawn.new(:white) }
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
      true
    end

    false
  end

  def valid_move(current_position, target_position)
    current_row, current_col = current_position
    target_row, target_col = target_position

    # Get piece
    piece = @board[current_row][current_col]

    # Check square between current and target position

    # Check if square is not empty and move is valid
    return false if piece.nil? || !piece.valid_moves(current_position, target_position)

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
      return true if piece.valid_moves(piece_position(piece), piece_position(king))
    end

    false
  end

  def checkmate?(color)
    # Find king
    king = find_king(color)
    king_position = piece_position(king)

    # Check if the king is in check
    return false unless check?(color)

    # Iterate through all possible moves for the king
    king_row, king_col = king_position
    (-1..1).each do |row_offset|
      (-1..1).each do |col_offset|
        next if row_offset == 0 && col_offset == 0

        target_row = king_row + row_offset
        target_col = king_col + col_offset

        # Check if the move is valid and doesn't put the king in check
        next unless valid_move(king_position, [target_row, target_col])

        temp_board = Board.new(@board)
        temp_board.make_move(king_position, [target_row, target_col])
        return false unless temp_board.check?(color)
      end
    end

    true
  end

  def stalemate?(color); end

  private

  def find_king(color)
    @board.flatten.find { |piece| piece.is_a?(King) && piece.color == color }
  end

  def find_pieces(color)
    @board.flatten.select do |piece|
      !piece.nil? && piece.color == color
    end
  end

  def piece_position(piece)
    @board.each_with_index do |row, row_index|
      col_index = row.index(piece)
      return [row_index, col_index] if col_index
    end
    nil
  end
end

board = Board.new
