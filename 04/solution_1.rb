def run
  lines = File.read(ARGV[0]).split("\n")

  numbers = lines.shift.split(',').map(&:to_i)

  boards = []
  boards.push(5.times.map { lines.shift.split.map(&:to_i) }) while lines.shift

  numbers.each do |num|
    boards = boards.map.with_index do |board, idx|
      board = mark(board, num)
      if win?(board)
        p "Board #{idx + 1} won"
        score = calculate_score(board, num)
        p "Score: #{score}"
        return
      end

      board
    end
  end
end

# Mark "X" on the board
def mark(board, num)
  board.map do |row|
    row.map do |item|
      if item == num
        'X'
      else
        item
      end
    end
  end
end

# Find if "X" lines up
def win?(board)
  # Check rows
  return true if board.any? { |row| row.all? { |item| item == 'X' } }

  # Check columns
  return true if board.transpose.any? { |col| col.all? { |item| item == 'X' } }

  # Check across
  # if (0..4).all? { |i| board[i][i] == "X" }
  #   return true
  # end

  # # Check across other way
  # if (0..4).all? { |i| board[i][4-i] == "X" }
  #   return true
  # end

  false
end

def calculate_score(board, num)
  unmarked = []

  board.each do |row|
    row.each do |item|
      unmarked.push item if item.is_a?(Integer)
    end
  end

  unmarked.sum * num
end

run
