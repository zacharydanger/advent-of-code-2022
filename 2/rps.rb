# For example, suppose you were given the following strategy guide:

# A Y
# B X
# C Z

# This strategy guide predicts and recommends the following:

    # In the first round, your opponent will choose Rock (A), and you should choose Paper (Y). This ends in a win for you with a score of 8 (2 because you chose Paper + 6 because you won).
    # In the second round, your opponent will choose Paper (B), and you should choose Rock (X). This ends in a loss for you with a score of 1 (1 + 0).
    # The third round is a draw with both players choosing Scissors, giving you a score of 3 + 3 = 6.

# In this example, if you were to follow the strategy guide, you would get a total score of 15 (8 + 1 + 6).

score = 0

rps = {
  rock: {
    beats: :scissors,
    score: 1,
    lookup: %w(A X)
  },
  paper: {
    beats: :rock,
    score: 2,
    lookup: %w(B Y)
  },
  scissors: {
    beats: :paper,
    score: 3,
    lookup: %w(C Z)
  }
}

throw_lookup = {}

rps.each do |k,v|
  v[:lookup].each do |val|
    throw_lookup[val] = k
  end
end

File.readlines('./input').each do |line|
  them, me = line.split(' ')

  my_throw = throw_lookup[me]
  their_throw = throw_lookup[them]

  round_points = rps[my_throw][:score]

  if rps[my_throw][:beats] == their_throw
    round_points += 6
  elsif my_throw == their_throw
    round_points += 3
  end

  puts "them #{their_throw}, me #{my_throw}, score #{round_points}"

  score += round_points
end

puts "Final Score: #{score}"

# --- Part Two ---

# The Elf finishes helping with the tent and sneaks back over to you. "Anyway, the second column says how the round needs to end: X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win. Good luck!"

# The total score is still calculated in the same way, but now you need to figure out what shape to choose so the round ends as indicated. The example above now goes like this:

    # In the first round, your opponent will choose Rock (A), and you need the round to end in a draw (Y), so you also choose Rock. This gives you a score of 1 + 3 = 4.
    # In the second round, your opponent will choose Paper (B), and you choose Rock so you lose (X) with a score of 1 + 0 = 1.
    # In the third round, you will defeat your opponent's Scissors with Rock for a score of 1 + 6 = 7.

# Now that you're correctly decrypting the ultra top secret strategy guide, you would get a total score of 12.

# Following the Elf's instructions for the second column, what would your total score be if everything goes exactly according to your strategy guide?

File.readlines('./input').each do |line|
  them, me = line.split(' ')

  # X = lose
  # Y = draw
  # Z = win

  their_throw = throw_lookup[them]

  if me == 'Y'
    my_throw = their_throw
  elsif me == 'X'
    my_throw = rps[their_throw][:beats]
  else

  end

  round_points = rps[my_throw][:score]

  if rps[my_throw][:beats] == their_throw
    round_points += 6
  elsif my_throw == their_throw
    round_points += 3
  end

  puts "them #{their_throw}, me #{my_throw}, score #{round_points}"

  score += round_points
end
