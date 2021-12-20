def run
  input = File.read(ARGV[0]).split("\n")

  algorithm = input.shift.split('')
  input.shift # Blank line
  image = input.map { |l| l.split('') }

  t = 2
  (t + 1).times do
    image = fill_border(image)
  end

  t.times do |n|
    puts "Pass : #{n + 1}"
    image = process(image, algorithm)
    print image
    count = image.map(&:join).join.count('#')
    puts "# Count : #{count}"
  end
end

def print(arr)
  puts arr.map(&:join)
end

def process(arr, algorithm)
  arr.map.with_index do |line, i|
    line.map.with_index do |_, j|
      # Get 3x3
      bits = arr.at(i - 1, j - 1) + arr.at(i - 1, j) + arr.at(i - 1, j + 1) +
             arr.at(i, j - 1) + arr.at(i, j) + arr.at(i, j + 1) +
             arr.at(i + 1, j - 1) + arr.at(i + 1, j) + arr.at(i + 1, j + 1)

      algo_idx = bits.tr('.#', '01').to_i(2)
      algorithm[algo_idx]
    end
  end
end

def fill_border(image)
  top_and_bottom = [['.'] * (image.first.size + 2)]

  top_and_bottom +
    image.map { |l| ['.'] + l + ['.'] } +
    top_and_bottom
end

class Array
  def at(y, x)
    return dig(0, 0) if y.negative? || x.negative?

    dig(y, x) || dig(0, 0)
  end
end

run
