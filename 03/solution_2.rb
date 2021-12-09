input = File.read(ARGV[0]).split("\n").map { |l| l.split('') }

def calculate_oxygen(input)
  idx = 0
  len = input.first.size
  while idx < len
    max = input.transpose[idx].tally.sort_by { |k, _v| -k.to_i }.max_by { |_k, v| v }.first

    input = input.select do |line|
      bit = line[idx]
      bit == max
    end

    if input.size == 1
      oxygen = input.first.join.to_i(2)
      break
    end

    idx += 1
  end

  oxygen
end

def calculate_co2(input)
  idx = 0
  len = input.first.size

  while idx < len
    min = input.transpose[idx].tally.sort_by { |k, _v| k.to_i }.min_by { |_k, v| v }.first

    input = input.select do |line|
      bit = line[idx]
      bit == min
    end

    if input.size == 1
      co2 = input.first.join.to_i(2)
      break
    end

    idx += 1
  end

  co2
end

puts "Oxygen: #{calculate_oxygen(input)}"
puts "CO2: #{calculate_co2(input)}"
puts "Answer: #{calculate_oxygen(input) * calculate_co2(input)}"
