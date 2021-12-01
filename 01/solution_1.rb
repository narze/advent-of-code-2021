count = -1
prev_line = 0

File.read(ARGV[0]).split("\n").map(&:to_i).each do |line|
  if line > prev_line
    count += 1
  end

  prev_line = line
end

puts "Output : #{count}"
