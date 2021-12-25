def run
  input = File.read(ARGV[0]).split("\n").map(&:chars)

  count = 0
  puts input.map(&:join)
  loop do
    puts count += 1
    new_input = iterate(input)
    puts new_input.map(&:join)

    break if new_input == input

    input = new_input
  end

  puts "Steps: #{count}"
end

def iterate(input)
  next_input = input.map(&:dup)

  next_input = next_input.map do |line|
    [line.last, *line, line.first].join.gsub('>.', '.>').split('')[1...-1]
  end

  next_input = next_input.transpose.map do |line|
    [line.last, *line, line.first].join.gsub('v.', '.v').split('')[1...-1]
  end

  next_input.transpose
end

run
