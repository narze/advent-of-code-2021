count = -1
prev_line = 0
File.read(ARGV[0]).split("\n").each do |line|
  if line.to_i > prev_line
    count += 1
  end

  prev_line = line.to_i
end

puts "Output : #{count}"
