# --- Part Two ---

# The Elf finishes helping with the tent and sneaks back over to you. "Anyway, the second column says how the round needs to end: X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win. Good luck!"

# The total score is still calculated in the same way, but now you need to figure out what shape to choose so the round ends as indicated. The example above now goes like this:

    # In the first round, your opponent will choose Rock (A), and you need the round to end in a draw (Y), so you also choose Rock. This gives you a score of 1 + 3 = 4.
    # In the second round, your opponent will choose Paper (B), and you choose Rock so you lose (X) with a score of 1 + 0 = 1.
    # In the third round, you will defeat your opponent's Scissors with Rock for a score of 1 + 6 = 7.

# Now that you're correctly decrypting the ultra top secret strategy guide, you would get a total score of 12.

# Following the Elf's instructions for the second column, what would your total score be if everything goes exactly according to your strategy guide?

rps = {
  rock: {
    score: 1,
    table: %i(scissors rock paper),
  },
  paper: {
    score: 2,
    table: %i(rock paper scissors),
  },
  scissors: {
    score: 3,
    table: %i(paper scissors rock)
  }
}

lookup = {
  'A' => :rock,
  'B' => :paper,
  'C' => :scissors,
}

score = 0

File.readlines('./input').each do |line|
  round_points = 0

  them, my_strat = line.split(' ')

  their_throw = lookup[them]

  table = rps[their_throw][:table]

  if my_strat  == 'Y'
    my_throw = their_throw
  elsif my_strat == 'X'
    my_throw = table[table.index(their_throw) - 1]
  else
    my_throw = table[table.index(their_throw) + 1]
  end

  round_points = rps[my_throw][:score]

  if table.index(my_throw) > table.index(their_throw)
    round_points += 6
  elsif my_throw == their_throw
    round_points += 3
  end

  puts "them #{their_throw}, me #{my_throw}, score #{round_points}"

  score += round_points
end

puts "SCORE: #{score}"
