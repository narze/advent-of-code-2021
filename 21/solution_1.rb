@default_dice = (1..100).to_a
def run
  input = File.read(ARGV[0]).split("\n")
  p1, p2 = input.map { |line| line.split(': ').last.to_i }

  p1_points = p2_points = 0

  dice_idx = 0

  rolls = 0

  loop do
    rolls += 3
    p1, dice_idx = roll(dice_idx, p1)
    p1_points += p1
    break if p1_points >= 1000

    rolls += 3
    p2, dice_idx = roll(dice_idx, p2)
    p2_points += p2
    break if p2_points >= 1000
  end

  p [:p1, p1_points]
  p [:p2, p2_points]
  p [:rolls, rolls]

  ans = if p1_points >= 1000
          p2_points * rolls
        else
          p1_points * rolls
        end

  puts "Answer: #{ans}"
end

def roll(idx, start, rolls = 3, dice = @default_dice)
  move = rolls.times.sum { |i| dice[(idx + i) % 100] }
  pts = (start + move - 1) % 10 + 1

  [pts, idx + rolls]
end

run
