def run
  input = File.read(ARGV[0]).chomp
  positions = input.split(",").map(&:to_i)

  med = positions.tally.max_by { |_,v| v }.first
  avg = positions.sum / positions.size

  range = med < avg ? med.upto(avg) : med.downto(avg)

  min_fuel = range.map { |v| positions.map { |p| (v - p).abs }.sum }.min

  puts min_fuel
end

run
