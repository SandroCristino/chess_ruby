require_relative '../lib/board'
require_relative '../lib/piece'

describe 'board' do
  describe 'valid move' do
    # Create instance
    board = Board.new

    it 'allowed moves' do
      # Pawn black two steps
      expect(board.valid_move([1, 1], [1, 3])).to be true

      # Knight black and white
      expect(board.valid_move([0, 1], [2, 0])).to be true
      expect(board.valid_move([7, 1], [5, 2])).to be true

      # Bishop black
      board.make_move([1, 1], [3, 1])
      expect(board.valid_move([0, 2], [1, 1])).to be true
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
end
