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
                if valid_move?(move)
                    make_move(move)
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

  def valid_move?(move)

    # Transform move format
    current_row = move[0].to_i + 1
    current_col = move[1].orb - 'a'.orb
    target_row = move[2].to_i + 1
    target_col = move[3].orb - 'a'.orb

    # Return true if move is valid
    return @board.valid_move([current_row, current_col], [target_row, target_col])
  end

  def make_move(move)
    # Make the move on the board
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