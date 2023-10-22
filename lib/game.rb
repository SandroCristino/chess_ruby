require_relative 'piece'
require_relative 'board'


class Game
    def initialize
        @board = Board.new
        @current_player = :white
        @winner = nil
    end

    def play
        until game_over?
            board.display
            puts "#{current_player}'s turn."
            begin
                move = get_player_move
                current_position, target_position = transform_move_format(move)
                if valid_move?(current_position, target_position)
                  make_move(current_position, target_position)
                  switch_players
                else
                    puts 'Invalid move. Please try again.'
                end
            rescue StandardError => e
                puts "Error: #{e.message}. Please try again."
            end 
        end

        display_result
    end

#   private

  def get_player_move
    puts "Enter valid move (e.g. e2 a3, b3 b5) or 'quit' to end the game."
    move = gets.chomp.downcase
    if move == 'quit'
        return 'quit'
    elsif valid_move_format(move)
        return move
    else
        puts 'Invalid move format. Please try again.'
        return get_player_move
    end
  end

  def valid_move_format(move)

    # Define pattern
    pattern = /^[a-hA-H][1-8][a-hA-H][1-8]$/
    
    # Check if move matches pattern and convert to boolean
    return !!move.match(pattern)
  end

  def transform_move_format(move)

     # Transform move format
     current_row = move[1].to_i - 1
     current_col = move[0].ord - 'a'.ord
     target_row = move[3].to_i - 1
     target_col = move[2].ord - 'a'.ord

    current_position = [current_row, current_col]
    target_position = [target_row, target_col]

    return current_position, target_position
  end

  def valid_move?(current_position, target_position)
    # Return true if move is valid
    return @board.valid_move(current_position, target_position)     
  end

  def make_move(current_position, target_position)
    # Get positions
    current_row, current_col = current_position
    target_row, target_col = target_position

    # Get color
    color = @board[current_row][current_col].color

    # Check casteling 
    if @board.check_position_queenside(current_position, target_position)
      @board.castle_queenside(color)
      return
    elsif @board.check_position_kingside(current_position, target_position)
      @board.castle_kingside(color)
      return
    end

    # Make move
    @board.make_move(current_position, target_position)

    # Check for promotion
    if @board.check_promotion(target_position)
      @board.run_promotion(target_position)
    end
  end

  def switch_players
    # Switch to the other player
  end

  def game_over?
    # Determine if the game is over (checkmate, stalemate, etc.)
  end

  def display_result
    # Display the game result (winner, draw, etc.)
  end

  def current_player
    # Return the current player (e.g., :white or :black)
  end
end

game = Game.new
move_pawn = 'h2h3'
move_knight = 'g1f3'
# game.valid_move?(move_pawn) 