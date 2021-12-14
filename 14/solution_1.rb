def run
  input = File.read(ARGV[0]).split("\n")

  template, _, *pairs = input

  p template
  pairs_map = pairs.map { |pair| pair.split(' -> ') }.to_h

  10.times do
    template = step(template, pairs_map)
  end

  tally = template.chars.tally
  p tally.values.max - tally.values.min
end

def step(template, pairs_map)
  next_state = template.chars.first

  template.chars.each_cons(2) do |a, b|
    # puts "a: #{a}, b: #{b}"
    # puts pairs_map["#{a}#{b}"]
    next_state += pairs_map["#{a}#{b}"] + b
  end

  next_state
end

run
