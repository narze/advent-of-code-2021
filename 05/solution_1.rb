def run
  lines = File.read(ARGV[0]).split("\n")

  straight_lines = lines.map do |line|
    x1y1, x2y2 = line.split(' -> ')
    x1, y1 = x1y1.split(',').map(&:to_i)
    x2, y2 = x2y2.split(',').map(&:to_i)

    # Consider only straight lines
    [x1, y1, x2, y2] if x1 == x2 || y1 == y2
  end.compact

  map = {}
  straight_lines.each do |(x1, y1, x2, y2)|
    x1, x2 = x2, x1 if x1 > x2
    y1, y2 = y2, y1 if y1 > y2

    (x1..x2).each do |x|
      (y1..y2).each do |y|
        map[[x, y]] ||= 0
        map[[x, y]] += 1
      end
    end
  end

  # p map

  ans = map.select { |_k, v| v > 1 }.size

  puts "Answer: #{ans}"
end

run
