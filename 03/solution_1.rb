
arr = File.read(ARGV[0]).split("\n").map { |l| l.split("") }.transpose

gamma_bits = arr.map { |col| col.tally.max_by { |k,v| v }.first }.join

gamma = gamma_bits.to_i(2)

epsilon_bits = gamma_bits.split("").map { |bit| bit == "1" ? "0" : "1" }.join

epsilon = epsilon_bits.to_i(2)

puts "Answer : #{gamma * epsilon}"
