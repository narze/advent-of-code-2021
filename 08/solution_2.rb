def run
  input = File.read(ARGV[0]).chomp
  lines = input.split("\n")

  values = lines.map do |line|
    segments, digits = line.split('|').map { |str| str.strip.split(' ') }

    seg_1 = sort_chars(segments.detect { |s| s.size == 2 })
    seg_7 = sort_chars(segments.detect { |s| s.size == 3 })
    seg_4 = sort_chars(segments.detect { |s| s.size == 4 })
    seg_8 = sort_chars(segments.detect { |s| s.size == 7 })

    seg_f = segments.join.chars.tally.detect { |_, v| v == 9 }.first
    seg_e = segments.join.chars.tally.detect { |_, v| v == 4 }.first

    seg_2 = sort_chars(segments.reject { |c| c.include?(seg_f) }.first)
    seg_c = (seg_1.chars - [seg_f]).first
    seg_b = seg_8.tr(seg_2, '').tr(seg_f, '')
    seg_d = seg_4.tr(seg_1, '').tr(seg_b, '')
    seg_0 = seg_8.tr(seg_d, '')

    seg_9 = seg_8.tr(seg_e, '')
    seg_3 = seg_9.tr(seg_b, '')
    seg_6 = seg_8.tr(seg_c, '')
    seg_5 = seg_6.tr(seg_e, '')

    mapping = {}
    mapping[seg_0] = '0'
    mapping[seg_1] = '1'
    mapping[seg_2] = '2'
    mapping[seg_3] = '3'
    mapping[seg_4] = '4'
    mapping[seg_5] = '5'
    mapping[seg_6] = '6'
    mapping[seg_7] = '7'
    mapping[seg_8] = '8'
    mapping[seg_9] = '9'

    digits.map { |seg| mapping[sort_chars(seg)] }.join.to_i
  end

  puts "Sum of digits: #{values.sum}"
end

def sort_chars(str)
  str.chars.sort.join
end

run
