def run
  point_map = {
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4,
  }

  input = File.read(ARGV[0]).split("\n").map { |l| l.split("") }

  points = []

  input.each do |line|
    stack = []
    corrupted = false

    line.each do |char|
      case char
      when "[", "{", "(", "<"
        stack.push(char)
      when "]"
        if stack.pop != "["
          corrupted = true
          next
        end
      when "}"
        if stack.pop != "{"
          corrupted = true
          next
        end
      when ")"
        if stack.pop != "("
          corrupted = true
          next
        end
      when ">"
        if stack.pop != "<"
          corrupted = true
          next
        end
      else
        raise "Unknown character: #{char}"
      end
    end

    if !corrupted
      point = 0

      stack.reverse.each do |char|
        point = 5 * point + point_map[char]
      end

      points.push point
    end
  end

  puts "Points: #{points}"
  puts "Middle Score: #{points.sort[points.size / 2]}"
end

run
