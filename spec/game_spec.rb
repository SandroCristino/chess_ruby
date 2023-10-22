require_relative '../lib/game'

describe 'game' do

    before(:each) do
        @game = Game.new
    end

    # Remove private in game.rb, 25 to use it
    describe 'get_player_move' do
        
        it 'return quit' do
            allow(@game).to receive(:gets).and_return("quit\n")
            expect(@game.get_player_move).to eq('quit')
        end

        it 'return valid move' do
            valid_move = 'e2e3'
            allow(@game).to receive(:gets).and_return("#{valid_move}\n")
            expect(@game.get_player_move).to eq(valid_move)
        end

        it 'prompts the player to retry' do
            invalid_move = 'invalid'
            valid_move = 'e2e3'
            allow(@game).to receive(:gets).and_return("#{invalid_move}\n", "#{valid_move}\n")
            expect do
                @game.get_player_move
            end.to output(/Invalid move format. Please try again./).to_stdout
        end
    end

    describe 'valid_move?' do
        it 'return true' do
            move_pawn = 'h2h3'
            move_knight = 'g1f3'
            current_position_pawn, target_position_pawn  = @game.transform_move_format(move_pawn)
            current_position_knight, target_position_knight = @game.transform_move_format(move_knight)
            expect(@game.valid_move?(current_position_pawn, target_position_pawn)).to be true
            expect(@game.valid_move?(current_position_knight, target_position_knight)).to be true
        end

        it 'return false' do
            move_rook = 'a1a5'
            move_queen = 'e1e8'
            current_position_rook, target_position_rook  = @game.transform_move_format(move_rook)
            current_position_queen, target_position_queen = @game.transform_move_format(move_queen)
            expect(@game.valid_move?(current_position_rook, target_position_rook)).to be false
            expect(@game.valid_move?(current_position_queen, target_position_queen)).to be false
        end
    end

end
