require_relative '../lib/board'
require_relative '../lib/piece'

describe 'board' do
  describe 'valid move' do
    # Create instance
    board = Board.new

    it 'allowed moves' do
      # Pawn black two steps
      expect(board.valid_move([1, 1], [3, 1])).to be true

      # Knight black and white
      expect(board.valid_move([0, 1], [2, 0])).to be true
      expect(board.valid_move([7, 1], [5, 2])).to be true

      # Bishop black
      board.make_move([1, 1], [3, 1])
      expect(board.valid_move([0, 2], [1, 1])).to be true
    end

    it 'check if square empty between current and target location' do
      board_template = Array.new(8) {Array.new(8, nil)}
      board_template[1][1] = Pawn.new(:black, [1,1])
      board_template[1][3] = Rook.new(:black, [1,3])
      board_template[2][2] = Pawn.new(:black, [2,2])
      board_template[3][1] = Bishop.new(:white, [3,1])

      new_board = Board.new(board_template)

      # Rook passes pawn
      expect(new_board.valid_move([1,3], [1,0])).to be false

      # Bishop passes pawn
      expect(new_board.valid_move([3,1], [1,3]))
    end

    it 'ilegal moves' do
      expect(board.valid_move([7, 1], [7, 4])).to be false
      expect(board.valid_move([0, 0], [6, 1])).to be false
    end
  end

  describe 'check?' do
    # Create instance
    board = Board.new

    # Prepare board for check
    board.make_move([1, 3], [2, 3])
    board.make_move([0, 4], [1, 3])
    board.make_move([6, 6], [4, 6])
    board.make_move([7, 5], [6, 6])
    board.make_move([6, 6], [2, 2])

    # FOR USING: DEACTIVATE PRIVATE IN BOARD CLASS

    # it 'return king location' do
    #     king_piece = board.find_king(:black)
    #     expect(king_piece).to be_instance_of(King)
    #     expect(king_piece.color).to eq(:black)
    # end

    it 'return true' do
      expect(board.check?(:black)).to be true
    end
  end

  describe 'checkmate?' do
    # Create instance
    board = Board.new

    # Prepare board for checkmate
    board.make_move([1, 3], [2, 3])
    board.make_move([0, 4], [1, 3])
    board.make_move([6, 6], [4, 6])
    board.make_move([7, 5], [6, 6])
    board.make_move([6, 6], [2, 2])
    board.make_move([2, 3], [3, 3])
    board.make_move([6, 7], [4, 7])
    board.make_move([7, 7], [5, 7])
    board.make_move([5, 7], [5, 4])
    board.make_move([5, 4], [2, 4])
    board.make_move([2, 4], [2, 3])
    board.make_move([6, 4], [4, 4])
    board.make_move([4, 4], [3, 4])
    board.make_move([3, 4], [2, 4])
    board.make_move([7, 3], [6, 4])
    board.make_move([6, 4], [3, 4])

    board.checkmate?(:black)
    it 'return true' do
      expect(board.checkmate?(:black)).to be true
    end
  end

  describe 'stalemate?' do
   
    it 'return true' do

      # Create board
      board_template = Array.new(8) { Array.new(8, nil) }
      board_template[2][3] = Queen.new(:white, [2,3])
      board_template[4][4] = Queen.new(:white, [4,4])
      board_template[1][0] = King.new(:black, [1,0])

      # Create instance
      board = Board.new(board_template)

      expect(board.stalemate?(:black)).to be true
    end

    it 'return false' do

      # Create instance
      board = Board.new

      expect(board.stalemate?(:white)).to be false
    end
  end

  describe 'draw?' do

    it 'return false' do
      board_template = Array.new(8) {Array.new(8, nil)}
      board_template[1][1] = King.new(:black, [1,2])
      board_template[4][1] = Pawn.new(:black, [4,2])
      board_template[6][6] = King.new(:white, [6,6])
      board_template[6][1] = Queen.new(:black, [6,1])

      board = Board.new(board_template)
      expect(board.draw?).to be false
    end

    it 'return true' do
      board_template = Array.new(8) {Array.new(8, nil)}
      board_template[1][1] = King.new(:black, [1,2])
      board_template[4][1] = Bishop.new(:black, [4,2])
      board_template[6][6] = King.new(:white, [6,6])
      board_template[6][1] = Bishop.new(:white, [6,1])

      board = Board.new(board_template)
      expect(board.draw?).to be true
    end
  end

  describe 'castling' do 

    before(:each) do
      # Preparing board
      temp_board = Array.new(8) { Array.new(8, nil) }
      temp_board[0][0] = Rook.new(:black, [0,0])
      temp_board[0][4] = King.new(:black, [0,4])
      temp_board[0][3] = Queen.new(:black, [0,3])
      temp_board[0][7] = Rook.new(:black, [0,7])
      temp_board[7][0] = Rook.new(:white, [7,0])
      temp_board[7][4] = King.new(:white, [7,4])
      temp_board[7][6] = Knight.new(:white, [7,6])
      temp_board[7][7] = Rook.new(:white, [7,7])

      # Create instance
      @board = Board.new(temp_board)
    end
  
    it 'Black kingside > allowed' do

      # Make move and get board state
      @board.castle_kingside(:black)
      board_state = @board.board

      expect(board_state[0][6]).to be_a(King)
      expect(board_state[0][5]).to be_a(Rook)
      expect(board_state[0][4]).to be_nil
      expect(board_state[0][7]).to be_nil
    end

    it 'Black queenside > ilegal' do
       # Make move and get board state
       @board.castle_queenside(:black)
       board_state = @board.board

       expect(board_state[0][4]).to be_a(King)
       expect(board_state[0][0]).to be_a(Rook)
    end

    it 'White kingside > ilegal' do
        # Make move and get board state
        @board.castle_kingside(:white)
        board_state = @board.board

        expect(board_state[7][4]).to be_a(King)
        expect(board_state[7][7]).to be_a(Rook)
    end

    it 'White queenside > allowed' do
        # Make move and get board state
        @board.castle_queenside(:white)
        board_state = @board.board

        expect(board_state[7][2]).to be_a(King)
        expect(board_state[7][3]).to be_a(Rook)
        expect(board_state[7][4]).to be_nil
        expect(board_state[7][0]).to be_nil
    end
end
end
