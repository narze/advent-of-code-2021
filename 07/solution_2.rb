def run
  input = File.read(ARGV[0]).chomp
  positions = input.split(',').map(&:to_i)

  med = positions.tally.max_by { |_, v| v }.first
  avg = positions.sum.to_f / positions.size

  range = med < avg ? med.upto(avg.ceil) : med.downto(avg.floor)

  fuel = range.map do |v|
    diff = positions.map do |p|
      d = (v - p).abs
      d * (d + 1) / 2
    end

    diff.sum
  end

  min_fuel = fuel.min

  puts min_fuel
end

run
