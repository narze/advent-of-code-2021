@pop = Hash.new(0)

(1..3).each do |i|
  (1..3).each do |j|
    (1..3).each do |k|
      @pop[i + j + k] += 1
    end
  end
end

def run
  input = File.read(ARGV[0]).split("\n")
  p1_init, p2_init = input.map { |line| line.split(': ').last.to_i }

  state = Hash.new(0)
  state[[p1_init, 0, p2_init, 0]] = 1

  p1_turn = true
  limit = 21

  loop do
    new_state = Hash.new(0)

    state.each do |(p1, p1_points, p2, p2_points), count|
      if p1_points >= limit || p2_points >= limit
        new_state[[p1, p1_points, p2, p2_points]] += count
      else
        @pop.each do |roll, times|
          if p1_turn
            new_p1 = (p1 + roll - 1) % 10 + 1
            new_p1_points = p1_points + new_p1
            new_state[[new_p1, new_p1_points, p2, p2_points]] += count * times
          else
            new_p2 = (p2 + roll - 1) % 10 + 1
            new_p2_points = p2_points + new_p2
            new_state[[p1, p1_points, new_p2, new_p2_points]] += count * times
          end
        end
      end
    end

    state = new_state

    if state.all? do |(_, p1_points, _, p2_points), _count|
      p1_points >= limit || p2_points >= limit
    end
      break
    end

    p1_turn = !p1_turn
  end

  # pp state

  p1_wins = state.select { |(_, p1_points, _, _), _| p1_points >= limit }.values.sum
  p2_wins = state.select { |(_, _, _, p2_points), _| p2_points >= limit }.values.sum

  p [p1_wins, p2_wins]
end

run
