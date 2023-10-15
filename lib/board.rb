require_relative 'piece'

class Board

    attr_reader :board

    # Initialize the board 8x8
    def initialize 
        @board = Array.new(8) {Array.new(8, nil)}
        setup_initialze(@board)
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
        grid[1].map! {|n| Pawn.new(:black)}

        # Initialize black
        grid[7][0] = Rook.new(:white)
        grid[7][1] = Knight.new(:white)
        grid[7][2] = Bishop.new(:white)
        grid[7][3] = Queen.new(:white)
        grid[7][4] = King.new(:white)
        grid[7][5] = Bishop.new(:white)
        grid[7][6] = Knight.new(:white)
        grid[7][7] = Rook.new(:white)
        grid[6].map! {|n| Pawn.new(:white)}
    end

    def display
        puts "    a   b   c   d   e   f   g   h "
        puts "  ---------------------------------"
    
        @board.each_with_index do |row, index|
          print "#{8 - index} |"
          row.each do |square|
            if square.nil?
              print "   |"
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
        valid_move = valid_move(current_position, target_position)

        # if @board[target_row][target_col].nil? || @board[target_row][target_col].color != piece.color
        if valid_move 

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

board = Board.new
board.make_move([1,1], [3,1])
board.display
board.valid_move([0,2], [1,1])

