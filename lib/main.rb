# frozen_string_literal: true

# Game concept:
# The game consists on 2 players placing pieces in a board of 6x7
# The players who gets 4 pieces of their color in horizontal, vertical or diagonal line wins
# Each player has a turn

# Logic:
# 1. Create a board with the following aspects:
#  ---> 6 holes tall and 7 holes wide, you can only add pieces from
#       the top that falls to the deepest empty hole.
#           --> We can achieve this with arrays or creating a new object
#               that can store multiple values as a column and row.
#  ---> Each piece fills a hole and act as a platform for other piece
#       to stand on, meaning you can only have one piece per hole.
#           --> We can use a stack here to simulate the pieces behavior
# 2. Create a piece (Not an object necessarily) that the player can use
#  ---> We can just use any data type to fill the array/object that
#       is acting as a hole and mark it with the player's color/data.
# 3. Pieces should always fall to the deepest empty hole.
#  ---> Start counting backwards until it finds an empty hole to place the piece.
# 4. The game ends when 4 pieces are aligned vertically, horizontally or diagonally.
#  ---> Using arrays would require some math involved, if we use a graph we could
#       create an adjacency list and that way check if it is aligned.

require 'colorize'
require 'pry-byebug'

class String
  def numeric?
    match?(/[[:digit:]]/)
  end
end

class ConnectFour
  attr_accessor :board

  RED = '●'.colorize(:red).freeze
  YELLOW = '●'.colorize(:yellow).freeze
  ADJ = [[0, -1], [0, 1], [-1, 0], [1, 0], [-1, -1], [1, -1], [-1, 1], [1, 1]].freeze

  def red
    RED
  end

  def yellow
    YELLOW
  end

  def initialize
    @board = Array.new(7) { Array.new(6, '●') }
  end

  def pretty_print(array = @board, row = 5)
    return '' if row.negative?

    output = ''
    counter = 0
    output = pretty_print(array, row - 1)
    array.length.times do
      output += "#{array[counter][row]}  "
      counter += 1
    end
    "#{output}\n"
  end

  def display_board
    puts "#{pretty_print}1  2  3  4  5  6  7"
  end

  def empty_slot?(string)
    string == '●'
  end

  def last_slot(array, index = array.length - 1)
    return nil if (index + array.length).zero?

    array[index] == '●' ? index : last_slot(array, index - 1)
  end

  def add_arrays(arr1, arr2)
    result = []
    result << arr1[0] + arr2[0]
    result << arr1[1] + arr2[1]
    result
  end

  # Places a piece in the board and returns its coordinate
  def place_piece(index, color = RED)
    return nil if (!index.is_a? Integer) || (index > @board.length - 1)

    last = last_slot(@board[index])
    @board[index][last] = color
    [index, last]
  end

  # Returns an array with coordinates if it finds a four in line
  # otherwise returns nil
  def four_in_line(arr, color)
    # Filter all movements that contain the same color.
    movements_queue = filter_movements(arr, color)

    until movements_queue.empty? do
      # The next move will be the first element of the queue.
      next_move = movements_queue.shift

      coordinates = [arr]
      3.times do
        # Fill the coordinates array with the possible winning line coordinates.
        next_coord = [coordinates.last[0] + next_move[0], coordinates.last[1] + next_move[1]]
        coordinates << next_coord
      end
      return coordinates if traverse(arr, next_move, color)
    end
    return nil if movements_queue.empty?
  end

  def check_for_surroundings(arr, color = RED)
    movements = filter_movements(arr, color)
    return movements if movements.empty?

    movements.map! do |element|
      add_arrays(element, arr)
    end
    movements << arr
    movements.each do |element|
      coordinates = four_in_line(element, color)
      return coordinates unless coordinates.nil?
    end
    []
  end

  # This method checks the surroundings of the slot and returns
  # the movement coordinates that contain the same color.
  def filter_movements(arr, color)
    ADJ.select do |element|
      x = arr[0] + element[0]
      y = arr[1] + element[1]
      @board[x][y] == color unless @board[x].nil? || @board[x][y].nil?
    end
  end

  # Iterate over 3 slots in the direction of the movement coordinates.
  # Return true if all contains the same color.
  def traverse(arr, movement, color, result = [])
    return false if result.include?(false)
    return true if result.length == 4
    return false if @board[arr[0]].nil? || @board[arr[0]][arr[1]].nil?

    if @board[arr[0]][arr[1]] == color
      result << @board[arr[0]][arr[1]]
    else
      result << false
    end

    traverse([arr[0] + movement[0], arr[1] + movement[1]], movement, color, result)
  end

  def get_input(color)
    puts "#{color} piece turn"
    puts 'Insert the position you want to place your piece at (0-6)'
    loop do
      input = gets.chomp
      return input.to_i if input.numeric? && (input.to_i > -1 && input.to_i < 7)

      puts 'Please enter a number in the valid range (0-6)'
    end
  end

  def win_condition(color)
    input = get_input(color) - 1
    move = place_piece(input, color)
    win = check_for_surroundings(move, color).sort
    if win.length == 4
      puts "#{color} wins!"
      return true
    end
    false
  end

  def clear_board
    @board = Array.new(7) { Array.new(6, '●') }
  end

  def restart_game
    loop do
      puts 'Do you want to play another round? Y/N'
      play_again = gets.chomp.upcase
      case play_again
      when 'Y'
        clear_board
        break
      when 'N'
        exit
      else
        puts 'Invalid input'
        next
      end
    end
  end

  def play_game
    loop do
      game_over = false
      color = RED
      display_board
      while game_over == false
        game_over = win_condition(color)
        display_board
        color = color == RED ? YELLOW : RED
      end
      restart_game
    end
  end
end

new_board = ConnectFour.new
new_board.play_game
