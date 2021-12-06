def run(days_count)
  input = File.read(ARGV[0]).chomp
  days = input.split(",").map(&:to_i).tally

  days_count.times do
  p  days = iterate(days)
  end

  puts "Days: #{days_count}, Size: #{days.values.sum}"

  days.values.sum
end

def iterate(days)
  new_days = {}

  days.each do |days, count|
    if days > 0
      new_days[days - 1] ||= 0
      new_days[days - 1] += count
    else
      new_days[6] ||= 0
      new_days[6] += count
      new_days[8] = count
    end
  end

  new_days
end

run(256)
