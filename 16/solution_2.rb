def run
  inputs = File.read(ARGV[0]).split("\n")

  inputs.each do |input|
    next if input[0] == '#'

    puts "Input: #{input}"

    input = input.to_i(16).to_s(2)
    # Add 0 padding
    input = '0' * (-input.length % 8) + input
    input = input.chars

    packets, _remaining_input = parse_packets(input)
    p 'packets', packets

    result = eval_packet(packets.first)

    puts "Result: #{result}"
  end
end

def eval_packet(packet)
  type = packet[:type]
  data = packet[:data]

  return data if type == 4

  packets = data.map { |sub_packet| eval_packet(sub_packet) }

  case type
  when 0 # Sum
    packets.reduce(:+)
  when 1 # Product
    packets.reduce(:*)
  when 2 # Min
    packets.min
  when 3 # Max
    packets.max
  when 5 # Gt
    packets[0] > packets[1] ? 1 : 0
  when 6 # Lt
    packets[0] < packets[1] ? 1 : 0
  when 7 # Eq
    packets[0] == packets[1] ? 1 : 0
  else
    raise "Unknown type: #{type}"
  end
end

def parse_packets(input, limit = 10_000)
  packets = []

  while input.any?
    version = input.shift(3).join.to_i(2)

    type = input.shift(3).join.to_i(2)

    data = nil

    if type == 4 # Literal
      num = []
      num.push input.shift(4) while input.shift != '0'
      num.push input.shift(4) # Last one

      data = num.join.to_i(2)
    else # Operator
      length_type = input.shift

      if length_type == '0'
        bits = input.shift(15).join
        bits_length = bits.to_i(2)

        data, = parse_packets(input.shift(bits_length))
      else
        sub_packets_length = input.shift(11).join.to_i(2)

        data, input = parse_packets(input, sub_packets_length)
      end
    end

    packets << {
      v: version,
      type: type,
      data: data
    }

    break if packets.size >= limit
  end

  [packets, input]
end

run
