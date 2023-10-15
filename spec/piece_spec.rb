require_relative '../lib/piece'

describe 'valid moves' do
  describe 'king' do
    # Create instance
    king = King.new(:black)

    it 'allowed moves' do
      # Horizontal move
      expect(king.valid_moves([3, 3], [3, 4])).to be true

      # Vertical move
      expect(king.valid_moves([3, 3], [3, 2])).to be true

      # Diagonal move
      expect(king.valid_moves([3, 3], [2, 2])).to be true
    end

    it 'ilegal moves' do
      expect(king.valid_moves([1, 1], [4, 4])).to be false
      expect(king.valid_moves([2, 2], [5, 4])).to be false
      expect(king.valid_moves([5, 5], [2, 4])).to be false
    end
  end

  describe 'queen' do
    # Create instance
    queen = Queen.new(:black)

    it 'allowed moves' do
      # Horizontal move
      expect(queen.valid_moves([3, 3], [3, 5])).to be true

      # Vertical move
      expect(queen.valid_moves([3, 3], [5, 3])).to be true

      # Diagonal move
      expect(queen.valid_moves([3, 3], [1, 1])).to be true
    end

    it 'ilegal move' do
      expect(queen.valid_moves([3, 3], [1, 2])).to be false
      expect(queen.valid_moves([3, 3], [5, 4])).to be false
      expect(queen.valid_moves([3, 3], [8, 1])).to be false
    end
  end

  describe 'rook' do
    # Create instance
    rook = Rook.new(:black)

    it 'allowed moves' do
      # Vertical move
      expect(rook.valid_moves([3, 3], [5, 3])).to be true

      # Horizontal move
      expect(rook.valid_moves([3, 3], [3, 5])).to be true
    end

    it 'ilegal moves' do
      expect(rook.valid_moves([3, 3], [1, 1])).to be false
      expect(rook.valid_moves([3, 3], [5, 1])).to be false
      expect(rook.valid_moves([3, 3], [1, 2])).to be false
    end
  end

  describe 'bishop' do
    # Create instance
    bishop = Bishop.new(:black)

    it 'allowed moves' do
      # Diagonal moves
      expect(bishop.valid_moves([3, 3], [1, 1])).to be true
      expect(bishop.valid_moves([4, 2], [3, 1])).to be true
      expect(bishop.valid_moves([5, 4], [3, 2])).to be true
    end

    it 'ilegal moves' do
      expect(bishop.valid_moves([3, 3], [1, 2])).to be false
      expect(bishop.valid_moves([4, 2], [1, 3])).to be false
      expect(bishop.valid_moves([5, 4], [3, 3])).to be false
    end
  end

  describe 'knight' do
    # Create instance
    knight = Knight.new(:black)

    it 'allowed moves' do
      expect(knight.valid_moves([3, 3], [4, 1])).to be true
      expect(knight.valid_moves([3, 3], [2, 1])).to be true
      expect(knight.valid_moves([3, 3], [1, 2])).to be true
      expect(knight.valid_moves([3, 3], [5, 2])).to be true
      expect(knight.valid_moves([3, 3], [5, 4])).to be true
      expect(knight.valid_moves([3, 3], [1, 4])).to be true
      expect(knight.valid_moves([3, 3], [2, 5])).to be true
      expect(knight.valid_moves([3, 3], [4, 5])).to be true
    end

    it 'ilegal moves' do
      expect(knight.valid_moves([3, 3], [1, 1])).to be false
      expect(knight.valid_moves([3, 3], [4, 3])).to be false
      expect(knight.valid_moves([3, 3], [2, 2])).to be false
      expect(knight.valid_moves([3, 3], [2, 3])).to be false
      expect(knight.valid_moves([3, 3], [1, 5])).to be false
    end
  end

  describe 'pawn' do
    # Create instance
    pawn_black = Pawn.new(:black)
    pawn_white = Pawn.new(:white)

    it 'allowed moves' do
      # One step ahead
      expect(pawn_black.valid_moves([3, 3], [4, 3])).to be true
      expect(pawn_black.valid_moves([4, 1], [5, 1])).to be true
      expect(pawn_white.valid_moves([3, 3], [2, 3])).to be true

      # Two steps if first move
      expect(pawn_black.valid_moves([1, 1], [3, 1])).to be true
      expect(pawn_white.valid_moves([6, 1], [4, 1])).to be true
    end

    it 'allowed moves' do
      # Ilegal horizintal move
      expect(pawn_black.valid_moves([3, 3], [2, 3])).to be false

      # Ilegal two steps move
      expect(pawn_black.valid_moves([4, 4], [4, 6])).to be false
    end
  end
end
