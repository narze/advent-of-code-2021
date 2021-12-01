count = -1
prev_input = 0

File.read(ARGV[0]).split("\n").map(&:to_i).each_cons(3) do |arr|
  input = arr.sum

  if input > prev_input
    count += 1
  end

  prev_input = input
end

puts "Output : #{count}"
