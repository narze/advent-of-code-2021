require 'set'

def run
  input = File.read(ARGV[0]).split("\n").map { |l| l.split("").map &:to_i}

  low_points = []

  input.each.with_index do |line, y|
    line.each.with_index do |point, x|
      is_low_point = [[y-1, x], [y+1, x], [y, x-1], [y, x+1]].all? do |yd, xd|
        point < input.at(yd, xd)
      end

      if is_low_point
        low_points << [y, x]
      end
    end
  end

  basin_sizes = low_points.map do |(y, x)|
    basin = create_basin(y, x, input)
    basin.size
  end

  top_3 = basin_sizes.sort.reverse[0..2]

  puts "Answer: #{top_3.reduce(:*)}"
end

def create_basin(y, x, arr, acc = Set[])
  acc.add([y, x])

  [[y-1, x], [y+1, x], [y, x-1], [y, x+1]].each do |(yd, xd)|
    if arr.at(yd, xd) < 9 && !acc.include?([yd, xd])
      acc.merge(create_basin(yd, xd, arr, acc))
    end
  end

  acc
end

class Array
  def at(y, x)
    return 10 if y.negative? || x.negative?

    self.dig(y, x) || 10
  end
end

run
