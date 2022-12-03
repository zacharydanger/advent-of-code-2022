# To help prioritize item rearrangement, every item type can be converted to a priority:

    # Lowercase item types a through z have priorities 1 through 26.
    # Uppercase item types A through Z have priorities 27 through 52.

# In the above example, the priority of the item type that appears in both compartments of each rucksack is 16 (p), 38 (L), 42 (P), 22 (v), 20 (t), and 19 (s); the sum of these is 157.

# Find the item type that appears in both compartments of each rucksack. What is the sum of the priorities of those item types?

class Ruckus
  attr_reader :raw

  def initialize(raw)
    @raw = raw
  end

  def compartments
    middle = raw.size / 2

    c1 = raw.slice(0...middle).split ''
    c2 = raw.slice(middle...raw.size).split ''

    [c1, c2]
  end

  def common_item
    (compartments[0] & compartments[1]).first
  end

  def common_score
    priorities[common_item]
  end

  def priorities
    @priorities ||= begin
                      priorities = {}

                      pri = 1

                      ("a".."z").each do |letter|
                        priorities[letter] = pri
                        pri += 1
                      end

                      ("A".."Z").each do |letter|
                        priorities[letter] = pri
                        pri += 1
                      end

                      priorities
                    end
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
