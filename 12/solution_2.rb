def run
  input = File.read(ARGV[0]).split("\n").map { |l| l.split('-') }

  starts = input.select { |(a, b)| a == 'start' || b == 'start' }
  others = input - starts

  completed_paths = []

  starts.each do |(a, b)|
    b, a = a, b if a != 'start'
    stack = []
    stack << [a, b]

    while stack.any?
      path = stack.pop

      if path.last == 'end'
        completed_paths << path
        next
      end

      has_same_small_cave_twice = path[1..-1].select { |p| p.small_cave? }.tally.values.include?(2)

      next_points = others.select { |m| m.include?(path.last) }.map { |m| m[0] == path.last ? m[1] : m[0] }

      next_points.each do |point|
        # Remaining small caves allowed only once
        if point.small_cave? && has_same_small_cave_twice && !path.include?(point)
          stack << path + [point]

        # Single small caves allowed twice
        elsif point.small_cave? && !has_same_small_cave_twice && path.count(point) < 2
          stack << path + [point]
        elsif point.big_cave?
          stack << path + [point]
        end
      end

      stack
    end
  end

  # puts completed_paths.map { |p| p.join(',') }
  puts "Answer: #{completed_paths.size} paths"
end

class String
  def small_cave?
    self[0].ord >= 97
  end

  def big_cave?
    !small_cave?
  end
end
run
