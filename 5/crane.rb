# CRANE!
class Crane
  attr_reader :raw_input

  def initialize(raw_input)
    @raw_input = raw_input
  end

  def stacks
    @stacks ||= parsed_stacks
  end

  def instructions
    @instructions ||= raw_input.split("\n\n").last.split("\n").map { |i| parse_instruction i }
  end

  def run!
    while ins = instructions.shift
      ins[:count].times do |i|
        stacks[ins[:dest]] << stacks[ins[:src]].pop
      end
    end
  end

  def output
    stacks.map { |k,s| s.last }.join('')
  end

  private

  def parse_instruction(instr)
    regex = /^move (\d+) from (\d) to (\d)$/

    count, src, dest = instr.match(regex).captures

    {
      count: count.to_i,
      src:   src,
      dest:  dest
    }
  end

  def parsed_stacks
    raw_stacks = raw_input.split("\n\n").first.split("\n").reverse

    index_line = raw_stacks.shift

    stack_index = index_line.split(" ").compact

    index_pos = Hash[stack_index.map { |i| [i, index_line.index(i)] }]

    stacks = Hash[stack_index.map { |i| [i, []] }]

    while row = raw_stacks.shift
      index_pos.each do |i, index|
        stacks[i] << row[index]
      end
    end

    stacks.each { |i, stack|
      stack.reject! { |v|
        v.nil? || v == ' '
      }
    }

    stacks
  end
end

class CrateMover9k < Crane
  def run!
    while ins = instructions.shift
      stacks[ins[:dest]] += stacks[ins[:src]].pop(ins[:count])
    end
  end
end

def solve_it(file_name)
  c = Crane.new File.read(file_name)

  c.run!

  c.output
end

def solve_it_too(file_name)
  c = CrateMover9k.new File.read(file_name)
  c.run!
  c.output
end

test_output = solve_it './test_input'

puts test_output

puts solve_it('./input')
puts
puts "#### PART 2 ####"
puts

puts solve_it_too './test_input'

puts solve_it_too './input'

