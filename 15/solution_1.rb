def run
  input = File.read(ARGV[0]).split("\n").map { |l| l.split('').map(&:to_i) }

  solution = Array.new(input.size) { Array.new(input.first.size, Float::INFINITY) }

  # Not counting top left corner
  solution[0][0] = input[0][0] = 0
  queue = []
  queue.push(dist: input[0][1], coord: [0, 1])
  queue.push(dist: input[1][0], coord: [1, 0])
  solution[0][1] = input[0][1]
  solution[1][0] = input[1][0]

  visited = {}
  visited[[0, 0]] = true

  prev = { [0, 0] => [0, 0] }

  while queue.any?
    queue.sort_by! { |q| q[:dist] }

    v = queue.shift
    visited[v[:coord]] = true

    next unless input.at(v[:coord][0], v[:coord][1])

    [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |(di, dj)|
      i = di + v[:coord][0]
      j = dj + v[:coord][1]

      next if input.at(i, j).nil?
      next if visited[[i, j]]

      alt = solution[v[:coord][0]][v[:coord][1]] + input[i][j]

      next unless alt < solution[i][j]

      solution[i][j] = alt

      prev[[i, j]] = [v[:coord][0], v[:coord][1]]
      queue.push(dist: alt, coord: [i, j])
    end
  end

  last = [input.length - 1, input.first.length - 1]
  path = [last]
  while (x = prev[last])
    path.unshift x
    last = x
  end

  puts 'Path:'
  p path

  puts "Risk level: #{solution.last.last}"
end

class Array
  def at(y, x)
    return nil if y.negative? || x.negative?

    dig(y, x)
  end
end

run
