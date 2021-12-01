count = -1
prev_input = 0

inputs = File.read(ARGV[0]).split("\n").map(&:to_i)

(0...inputs.size-2).each do |idx|
  input = inputs[idx] + inputs[idx+1] + inputs[idx+2]

  if input > prev_input
    count += 1
  end

  prev_input = input
end

puts "Output : #{count}"
