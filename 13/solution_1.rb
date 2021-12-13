def run
  input = File.read(ARGV[0]).split("\n")

  blank_index = input.index('')
  dots = input[0...blank_index].map { |line| line.split(',').map(&:to_i) }
  folds = input[blank_index + 1..-1].map { |l| l.split('along ').last.split('=') }

  w = dots.map { |d| d[0] }.max + 1
  h = dots.map { |d| d[1] }.max + 1

  paper = Array.new(h) { Array.new(w) { '.' } }

  dots.each do |(x, y)|
    paper[y][x] = '#'
  end

  # First fold only
  folds = [folds.first]

  folds.each do |(direction, distance)|
    distance = distance.to_i

    paper = case direction
            when 'x'
              fold_x(paper, distance)
            when 'y'
              fold_y(paper, distance)
            else
              raise "Unknown direction: #{direction}"
            end
  end

  puts paper.map(&:join)

  puts "Dots count: #{paper.flatten.count('#')}"
end

def fold_y(paper, y)
  new_paper = Array.new(y) { Array.new(paper.first.size) { '.' } }

  new_paper.map.with_index do |row, y_idx|
    row.map.with_index do |_cell, x_idx|
      upper = paper.dig(y_idx, x_idx)
      lower = paper.dig(y * 2 - y_idx, x_idx)

      [upper, lower].include?('#') ? '#' : '.'
    end
  end
end

def fold_x(paper, x)
  fold_y(paper.transpose, x).transpose
end

run
