class Foo
  attr_reader :x, :cycles

  def initialize
    @x = 1
    @cycles = []
  end

  def noop
    cycle!
  end

  def addx(val)
    cycle!
    cycle!
    @x += val.to_i
  end

  def cycle!
    @cycles << @x
    puts "cycle ##{@cycles.count}: #{@x}"
  end

  def run(line)
    puts "RUN: #{line}"
    arguments = line.split

    command = arguments.shift

    send(command.to_sym, *arguments)
  end

  def signal_strengths(start: 20, step: 40)
    signals = []

    index = start - 1

    while c = cycles[index]
      strength = (index + 1) * c
      puts "#{index}: #{strength}"
      signals << strength
      index += step
    end

    signals.sum
  end
end

def solve(file)
  signal = Foo.new

  File.readlines(file).each do |line|
    signal.run line
  end

  signal.signal_strengths
end

output = solve './test_input'

if output == 13140
  puts "TEST PASSED"
else
  puts "TEST FAILED #{output.inspect} / 13140"
  abort
end

puts "REAL OUTPUT: #{solve('./input')}"
