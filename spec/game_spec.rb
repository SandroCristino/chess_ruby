require_relative '../lib/game'

describe 'game' do
  # Remove private in game.rb, 25 to use it
  describe 'get_player_move' do
    game = Game.new

    it 'return quit' do
      allow(game).to receive(:gets).and_return("quit\n")
      expect(game.get_player_move).to eq('quit')
    end

    it 'return valid move' do
      valid_move = 'e2e3'
      allow(game).to receive(:gets).and_return("#{valid_move}\n")
      expect(game.get_player_move).to eq(valid_move)
    end

    it 'prompts the player to retry' do
      invalid_move = 'invalid'
      valid_move = 'e2e3'
      allow(game).to receive(:gets).and_return("#{invalid_move}\n", "#{valid_move}\n")
      expect do
        game.get_player_move
      end.to output(/Invalid move format. Please try again./).to_stdout
    end
  end

  describe 'valid_move?' do
    game = Game.new

    it 'return true' do
      move_pawn = 'h2h3'
      move_knight = 'g1f3'
      current_position_pawn, target_position_pawn = game.transform_move_format(move_pawn)
      current_position_knight, target_position_knight = game.transform_move_format(move_knight)
      expect(game.valid_move?(current_position_pawn, target_position_pawn)).to be true
      expect(game.valid_move?(current_position_knight, target_position_knight)).to be true
    end

    it 'return false' do
      move_rook = 'a1a5'
      move_queen = 'e1e8'
      current_position_rook, target_position_rook = game.transform_move_format(move_rook)
      current_position_queen, target_position_queen = game.transform_move_format(move_queen)
      expect(game.valid_move?(current_position_rook, target_position_rook)).to be false
      expect(game.valid_move?(current_position_queen, target_position_queen)).to be false
    end
  end

  describe 'make move' do
    before(:each) do
      # Create template
      board_template = Array.new(8) { Array.new(8, nil) }

      # Casteling
      board_template[0][0] = Rook.new(:black, [0, 0])
      board_template[0][4] = King.new(:black, [0, 4])
      board_template[0][5] = Bishop.new(:black, [0, 5])
      board_template[0][7] = Rook.new(:black, [0, 7])

      # Legal
      board_template[7][6] = Knight.new(:black, [7, 6])
      board_template[4][4] = Queen.new(:black, [4, 4])

      @game = Game.new(board_template)
    end

    it 'castling > legal' do
      @game.make_move([0, 4], [0, 2])
      board_state = @game.instance_variable_get(:@board).board

      expect(board_state[0][2]).to be_a(King)
      expect(board_state[0][3]).to be_a(Rook)
      expect(board_state[0][4]).to be_nil
    end

    it 'castling > ilegal' do
      @game.make_move([0, 4], [0, 6])
      board_state = @game.instance_variable_get(:@board).board

      expect(board_state[0][4]).to be_a(King)
      expect(board_state[0][7]).to be_a(Rook)
    end

    it 'regular legal move' do
      @game.make_move([7, 6], [6, 4])
      @game.make_move([4, 4], [2, 2])
      board_state = @game.instance_variable_get(:@board).board

      expect(board_state[6][4]).to be_a(Knight)
      expect(board_state[2][2]).to be_a(Queen)
    end
  end
end
