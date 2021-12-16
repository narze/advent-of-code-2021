def run
  inputs = File.read(ARGV[0]).split("\n")

  inputs.each do |input|
    puts "Input: #{input}"

    input = input.to_i(16).to_s(2)
    # Add 0 padding
    input = '0' * (-input.length % 4) + input
    input = input.chars

    packets, _remaining_input = parse_packets(input)

    sum = sum_packet_versions(packets)

    puts "Packet versions sum: #{sum}"
  end
end

def sum_packet_versions(packets)
  version_sum = 0

  packets.each do |packet|
    version_sum += packet[:v]

    version_sum += sum_packet_versions(packet[:data]) if packet[:t] == 'Operators'
  end

  version_sum
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
        bits_length = input.shift(15).join.to_i(2)

        data, = parse_packets(input.shift(bits_length))
      else
        sub_packets_length = input.shift(11).join.to_i(2)

        data, input = parse_packets(input, sub_packets_length)
      end
    end

    packets << {
      v: version,
      t: type == 4 ? 'Literals' : 'Operators',
      data: data
    }

    break if packets.size >= limit
  end

  [packets, input]
end

run
