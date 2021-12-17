def run
  input = File.read(ARGV[0]).chomp.split(':').last.split(',')
  x_range = eval(input[0].split('=').last)
  y_range = eval(input[1].split('=').last)

  p input, x_range, y_range

  possible_x = []
  max_x = x_range.max
  max_x.downto(1).each do |x|
    # Find if x can go into x_range
    path = calc_x(x)

    possible_x << x if path.any? { |p| x_range.cover?(p) }
  end

  max_y = y_range.min.abs - 1
  min_y = y_range.min

  possible_y = (min_y..max_y).to_a.select do |y|
    y_possible?(y, min_y, y_range)
  end

  result = possible_x.product(possible_y).select do |vx, vy|
    possible = nil
    x = y = 0

    loop do
      x += vx
      y += vy

      if vx > 0
        vx -= 1
      elsif vx < 0
        vx += 1
      end

      vy -= 1

      if x_range.cover?(x) && y_range.cover?(y)
        possible = true
        break
      end

      if y < min_y
        possible = false
        break
      end
    end

    possible
  end

  puts "Number of possible velocities: #{result.size}"
end

def calc_x(x)
  path = []
  total = 0

  loop do
    total += x
    path << total

    if x > 0
      x -= 1
    elsif x < 0
      x += 1
    else
      break
    end
  end

  path
end

def y_possible?(y, min_y, y_range)
  total = 0

  loop do
    total += y

    y -= 1

    if y_range.cover? total
      return true
    elsif total < min_y
      return false
    end
  end
end

run
