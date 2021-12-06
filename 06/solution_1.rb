def run
  input = File.read(ARGV[0]).chomp
  days = input.split(",").map(&:to_i)

  80.times do
    days = iterate(days)
  end

  puts days.size
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

run
