x = 0
y = 0
a = 0

File.read(ARGV[0]).split("\n").each do |line|
  pos, unit = line.split(' ')
  unit = unit.to_i

  case pos
  when 'forward'
    x += unit
    y += a * unit
  when 'up'
    a -= unit
  when 'down'
    a += unit
  else
    raise 'Bad input'
  end
end

puts "Output : #{x * y}"
