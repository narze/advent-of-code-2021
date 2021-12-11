def run
  input = File.read(ARGV[0]).chomp.split("\n").map { |line| line.split('').map(&:to_i) }
  steps = 0

  loop do
    steps += 1
    input, count = step(input)

    break if count == 100
  end

  puts input.map { |l| l.join('') }
  puts "Synchronized step: #{steps}"
end

def step(data)
  # increase energy by 1
  data = data.map do |line|
    line.map do |col|
      col + 1
    end
  end

  # flash if energy greater than 9, loop until no more 9's
  flashed = []
  new_flashes = true

  while new_flashes
    new_flashes = false

    data.each.with_index do |line, y|
      line.each.with_index do |col, x|
        if col > 9 && !flashed.include?([y, x])
          new_flashes = true

          flashed.push [y, x]
          # add 1 to adjacent cells
          [-1, 0, 1].each do |dy|
            [-1, 0, 1].each do |dx|
              next if dy == 0 && dx == 0
              next if y + dy < 0 || y + dy >= 10
              next if x + dx < 0 || x + dx >= 10

              data[y + dy][x + dx] += 1
            end
          end
        end
      end
    end
  end

  # reset energy to 0
  data = data.map do |line|
    line.map do |col|
      if col > 9
        0
      else
        col
      end
    end
  end

  [data, flashed.size]
end

run
