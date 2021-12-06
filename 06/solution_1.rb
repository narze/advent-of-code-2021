def run(days_count)
  input = File.read(ARGV[0]).chomp
  days = input.split(",").map(&:to_i)

  days_count.times do
    days = iterate(days)
  end

  puts "Days: #{days_count}, Size: #{days.size}"
end

def iterate(days)
  days.map! do |d|
    d -= 1

    if d.negative?
      d = 6
      days.push(9)
    end

    d
  end

  days
end

run(80)
