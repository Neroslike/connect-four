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

class ConnectFour
  attr_accessor :board

  @@RED = "●".colorize(:red)
  @@YELLOW = "●".colorize(:yellow)

  def initialize
    @board = @arr = Array.new(7, Array.new(6, @@RED))
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
end

new_board = ConnectFour.new
new_board.display_board
