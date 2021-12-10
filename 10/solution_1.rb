def run
  point_map = {
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137,
  }

  input = File.read(ARGV[0]).split("\n").map { |l| l.split("") }

  points = 0

  input.each do |line|
    stack = []

    line.each do |char|
      case char
      when "[", "{", "(", "<"
        stack.push(char)
      when "]"
        if stack.pop != "["
          points += point_map["]"]
        end
      when "}"
        if stack.pop != "{"
          points += point_map["}"]
        end
      when ")"
        if stack.pop != "("
          points += point_map[")"]
        end
      when ">"
        if stack.pop != "<"
          points += point_map[">"]
        end
      else
        raise "Unknown character: #{char}"
      end
    end
  end

  puts "Points: #{points}"
end

run
