def run
  input = File.read(ARGV[0]).chomp.split(':').last.split(',')
  x_range = eval(input[0].split('=').last)
  y_range = eval(input[1].split('=').last)

  p input, x_range, y_range

  # Find minimum x & maximum y
  x = 1
  possible_x = []
  loop do
    final_x = calc_x(x)

    if final_x < x_range.first
      x += 1
    elsif x_range.cover?(final_x)
      possible_x << x
      x += 1
    else
      break
    end
  end

  p possible_x

  lowest_y = y_range.to_a.min.abs - 1

  height = lowest_y * (lowest_y + 1) / 2

  puts "Initial velocity #{possible_x.first},#{lowest_y} & height #{height}"
end

def calc_x(x)
  total = 0

  loop do
    total += x

    if x > 0
      x -= 1
    elsif x < 0
      x += 1
    else
      return total
    end
  end
end

run
