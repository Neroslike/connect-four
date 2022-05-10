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
        expect(game_board.last_slot(board)).to eql(2)
      end
    end

    context 'when 2 elements are present in a 4 element array' do
      before do
        allow(game_board).to receive(:puts)
      end

      it 'return the last unused slot(1)' do
        game_board.board = ["●", "●", 5, 4]
        board = game_board.board
        expect(game_board.last_slot(board)).to eql(1)
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
        game_board.place_piece(0, const)
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
        game_board.place_piece(0, const)
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

  describe '#four_in_line' do
    context 'when there is four in a horizontal line' do
      it 'returns array with the coordinates' do
        const = described_class::RED
        game_board.place_piece(0, const)
        game_board.place_piece(1, const)
        game_board.place_piece(2, const)
        game_board.place_piece(3, const)
        expect(game_board.four_in_line([0, 5], const)).to contain_exactly([0, 5], [1, 5], [2, 5], [3, 5])
      end
    end

    context 'when there is three in a horizontal line' do
      it 'returns nil' do
        const = described_class::RED
        game_board.place_piece(0, const)
        game_board.place_piece(1, const)
        game_board.place_piece(2, const)
        game_board.place_piece(3, 2)
        expect(game_board.four_in_line([0, 5], const)).to eq(nil)
      end
    end

    context 'when there is four in a vertical line' do
      it 'returns array with the coordinates' do
        const = described_class::RED
        game_board.place_piece(0, const)
        game_board.place_piece(0, const)
        game_board.place_piece(0, const)
        game_board.place_piece(0, const)
        expect(game_board.four_in_line([0, 5], const)).to contain_exactly([0, 5], [0, 4], [0, 3], [0, 2])
      end
    end

    context 'when there is four in a diagonal line' do
      it 'returns array with the coordinates' do
        const = described_class::RED
        game_board.board[0][5] = const
        game_board.board[1][4] = const
        game_board.board[2][3] = const
        game_board.board[3][2] = const
        expect(game_board.four_in_line([0, 5], const)).to contain_exactly([0, 5], [1, 4], [2, 3], [3, 2])
      end
    end
  end

  describe '#filter_movements' do
    context 'when the slot is a corner' do
      it 'returns array with movement coordinates that match the color' do
        const = described_class::RED
        game_board.place_piece(0, const)
        game_board.place_piece(1, const)
        expect(game_board.filter_movements([0, 5], const)).to contain_exactly([1, 0])
      end
    end

    context 'when the slot is a corner' do
      it 'returns array with movement coordinates that match the color' do
        const = described_class::RED
        game_board.place_piece(0, const)
        game_board.place_piece(0, const)
        game_board.place_piece(1, const)
        game_board.place_piece(1, const)
        expect(game_board.filter_movements([0, 5], const)).to contain_exactly([0, -1], [1, 0], [1, -1])
      end
    end
  end

  describe '#get_input' do
    context 'when input is a number between 0 and 6' do
      before do
        valid_input = '4'
        allow(game_board).to receive(:puts).twice
        allow(game_board).to receive(:gets).and_return(valid_input).once
      end

      it 'breaks the loop without sending an error message' do
        error_message = 'Please enter a number in the valid range (0-6)'
        expect(game_board).not_to receive(:puts).with(error_message)
        game_board.get_input(nil)
      end
    end

    context 'when input is invalid once, then a valid input' do
      before do
        invalid_input = '7'
        valid_input = '2'
        allow(game_board).to receive(:puts).thrice
        allow(game_board).to receive(:gets).and_return(invalid_input, valid_input)
      end

      it 'sends an error message' do
        error_message = 'Please enter a number in the valid range (0-6)'
        expect(game_board).to receive(:puts).with(error_message).once
        game_board.get_input(nil)
      end
    end
  end

  describe '#traverse' do
    context 'when there are four in a line' do
      it 'returns true' do
        const = described_class::RED
        game_board.place_piece(0, const)
        game_board.place_piece(1, const)
        game_board.place_piece(2, const)
        game_board.place_piece(3, const)
        expect(game_board.traverse([0, 5], [1, 0], const)).to be(true)
      end
    end
  end
end
