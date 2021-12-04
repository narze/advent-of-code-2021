def run
  lines = File.read(ARGV[0]).split("\n")

  numbers = lines.shift.split(",").map(&:to_i)

  boards = []

  while lines.shift
    boards.push(5.times.map { lines.shift.split.map(&:to_i) })
  end

  numbers.each do |num|
    boards = boards.map.with_index do |board, idx|
      next unless board

      board = mark(board, num)

      if win?(board)
        if boards.compact.size == 1
          p "Board #{idx + 1} won last"
          score = calculate_score(board, num)
          p "Score: #{score}"

          return
        end

        board = nil
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
        "X"
      else
        item
      end
    end
  end
end

# Find if "X" lines up
def win?(board)
  # Check rows
  if board.any? { |row| row.all? { |item| item == "X" } }
    return true
  end

  # Check columns
  if board.transpose.any? { |col| col.all? { |item| item == "X" } }
    return true
  end

  return false
end

def calculate_score(board, num)
  unmarked = []

  board.each do |row|
    row.each do |item|
      if item.is_a?(Integer)
        unmarked.push item
      end
    end
  end

  unmarked.sum * num
end

run
