def run
  input = File.read(ARGV[0]).chomp
  lines = input.split("\n")

  appearances = lines.map do |line|
    segments, digits = line.split("|").map { |str| str.strip.split(" ") }

    seg_1 = segments.detect { |s| s.size == 2 }.split("").sort.join
    seg_7 = segments.detect { |s| s.size == 3 }.split("").sort.join
    seg_4 = segments.detect { |s| s.size == 4 }.split("").sort.join
    seg_8 = segments.detect { |s| s.size == 7 }.split("").sort.join

    digits.size - (digits.map { |d| d.split("").sort.join } - [seg_1, seg_4, seg_7, seg_8]).size
  end

  puts "1,4,7,8 appearances: #{appearances.sum}"
end

run
