require_relative '../lib/board'
require_relative '../lib/piece'

describe 'board' do


    describe 'valid move' do

        # Create instance
        board = Board.new

        it 'allowed moves' do

            # Pawn black two steps 
            expect(board.valid_move([1,1], [1,3])).to be true

            # Knight black and white
            expect(board.valid_move([0,1], [2,0])).to be true
            expect(board.valid_move([7,1], [5,2])).to be true

            # Bishop black
            board.make_move([1,1], [3,1])
            board.display
            expect(board.valid_move([0,2], [1,1])).to be true
        end

        it 'ilegal moves' do
            expect(board.valid_move([7,1], [7,4])).to be false
            expect(board.valid_move([0,0], [6,1])).to be false
        end
    end
end
