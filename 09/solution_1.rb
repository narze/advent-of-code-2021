def run
  input = File.read(ARGV[0]).split("\n").map { |l| l.split('').map(&:to_i) }

  p input
  p input.at(1, 1)
  low_points = []

  input.each.with_index do |line, y|
    line.each.with_index do |point, x|
      is_low_point = [[y - 1, x], [y + 1, x], [y, x - 1], [y, x + 1]].all? do |yd, xd|
        point < input.at(yd, xd)
      end

      low_points << point if is_low_point
    end
  end

  p low_points
  risk_level = low_points.sum + low_points.count
  puts "Risk level #{risk_level}"
end

class Array
  def at(y, x)
    return 10 if y.negative? || x.negative?

    dig(y, x) || 10
  end
end

run
