require './lib/main'

describe ConnectFour do
  subject(:game_board) { described_class.new }

  describe '#last_slot' do
    context 'when only 1 element if present in a 4 element array' do
      before do
        allow(game_board).to receive(:puts)
      end

      it 'return the last unused slot index(2)' do
        game_board.board = ["●", "●", "●", 4]
        board = game_board.board
        expect(game_board.last_slot(board)).to eql(-2)
      end
    end

    context 'when 2 elements are present in a 4 element array' do
      before do
        allow(game_board).to receive(:puts)
      end

      it 'return the last unused slot(1)' do
        game_board.board = ["●", "●", 5, 4]
        board = game_board.board
        expect(game_board.last_slot(board)).to eql(-3)
      end
    end

    context 'when the column is full' do
      it 'return nil' do
        game_board.board = [1, 6, 5, 4]
        board = game_board.board
        expect(game_board.last_slot(board)).to eql(nil)
      end
    end
  end

  describe '#place_piece' do
    context 'when it has a valid index' do
      const = described_class::RED
      it 'update array value at index' do
        game_board.board = [['●', '●', '●', '●', '●']]
        game_board.place_piece(0, 1)
        board = game_board.board
        expect(board[0][-1]).to eq(const)
      end
    end

    context 'when it has an invalid index' do
      it 'return nil' do
        game_board.board = [['●', '●', '●', '●', '●']]
        expect(game_board.place_piece(4, 'x')).to eq(nil)
      end
    end

    context 'when column is partially filled' do
      const = described_class::RED
      it 'place piece at last unused slot' do
        game_board.board = [['●', '●', '●', const, const]]
        game_board.place_piece(0, 1)
        expect(game_board.board[0][2]).to eq(const)
      end
    end
  end

  describe '#empty_slot?' do
    context 'when the slot is empty' do
      it 'return true' do
        game_board.board = [['●', '●', '●', '●', '●']]
        board = game_board.board
        expect(game_board.empty_slot?(board[0][0])).to be(true)
      end
    end

    context 'when the slot is filled' do
      const = described_class::RED
      it 'return false' do
        game_board.board = [[const, '●', '●', '●', '●']]
        board = game_board.board
        expect(game_board.empty_slot?(board[0][0])).to be(false)
      end
    end
  end

  describe '#surroundings' do
    context 'when the slot being checked is a corner' do
      it 'returns only the coordinates that are accessible (0, 5)' do
        expect(game_board.surroundings(0, 5)).to contain_exactly([0, 4], [1, 4], [1, 5])
      end

      it 'returns only the coordinates that are accessible (6, 2)' do
        expect(game_board.surroundings(6, 2)).to contain_exactly([6, 1], [5, 1], [5, 2], [5, 3], [6, 3])
      end
    end
  end
end
