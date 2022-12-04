# To help prioritize item rearrangement, every item type can be converted to a priority:

    # Lowercase item types a through z have priorities 1 through 26.
    # Uppercase item types A through Z have priorities 27 through 52.

# In the above example, the priority of the item type that appears in both compartments of each rucksack is 16 (p), 38 (L), 42 (P), 22 (v), 20 (t), and 19 (s); the sum of these is 157.

# Find the item type that appears in both compartments of each rucksack. What is the sum of the priorities of those item types?

def priorities
  pri = 1
  {}.tap do |priors|
    ("a".."z").each do |letter|
      priors[letter] = pri
      pri += 1
    end

    ("A".."Z").each do |letter|
      priors[letter] = pri
      pri += 1
    end
  end
end

def score(item)
  priorities[item]
end

class Ruckus
  attr_reader :raw

  def initialize(raw)
    @raw = raw.strip
  end

  def items
    raw.split ''
  end

  def compartments
    middle = items.size / 2

    c1 = items.slice(0...middle)
    c2 = items.slice(middle...items.size)

    [c1, c2]
  end

  def common_item
    (compartments[0] & compartments[1]).first
  end

  def common_score
    score common_item
  end

end

def score_file(input_file)
  File.readlines(input_file).map do |line|
    Ruckus.new(line).common_score
  end.sum
end

test_output = score_file('./test_input')

if test_output == 157
  puts "TEST WORKED. PARTY."
else
  puts "TEST FAILED: Expected 157, got #{test_output}"
  abort
end

puts "REAL SCORE: #{score_file('./input')}"

def badge_score(input_file)
  rucks = File.readlines(input_file).map do |line|
    Ruckus.new(line)
  end

  wtf = rucks.each_slice(3).map do |a,b,c|
    score (a.items & b.items & c.items).first
  end.sum
end

test_score = badge_score('./test_input2')

if 70 != test_score
  puts "TEST FAILED: expected 70, got #{test_score.inspect}"
end

real_badge_score = badge_score('./input2')

puts "REAL BADGE SCORE: #{real_badge_score}"
