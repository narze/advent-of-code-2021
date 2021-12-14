def run
  input = File.read(ARGV[0]).split("\n")

  template, _, *pairs = input

  tally = {}
  tally[template[-1]] = 1

  pairs_map = pairs.map { |pair| pair.split(' -> ') }.to_h

  template = template.chars.each_cons(2).to_a.map { |a, b| a + b }.tally

  40.times do
    template = step(template, pairs_map)
  end

  template.each do |k, count|
    char = k[0]
    tally[char] ||= 0
    tally[char] += count
  end

  puts tally
  puts "Diff: #{tally.values.max - tally.values.min}"
end

def step(template, pairs_map)
  new_template = {}

  template.each do |k, count|
    left = k[0] + pairs_map[k]
    right = pairs_map[k] + k[1]

    new_template[left] ||= 0
    new_template[left] += count
    new_template[right] ||= 0
    new_template[right] += count
  end

  new_template
end

run
