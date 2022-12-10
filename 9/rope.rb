test_input = <<~TI
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
TI

class Point
  attr_reader :x, :y, :tail, :history, :name

  def initialize(x, y, tail: nil, name: nil)
    @x, @y, @tail, @name = x, y, tail, name
    @history = []
    save_history!
  end

  def move_by(x, y)
    if x.abs == 1 && y.abs == 1
      # diagonal move!
      @x += x
      @y += y
      save_history!
      tail&.trail!(self)
    else
      x.abs.times do |i|
        step = x > 0 ? 1 : -1
        @x += step
        save_history!
        tail&.trail!(self)
      end

      y.abs.times do |i|
        step = y > 0 ? 1 : -1
        @y += step
        save_history!
        tail&.trail!(self)
      end
    end
  end

  def trail!(point)
    return unless need_to_follow?(point)

    x_delta, y_delta = diff(point)

    x_step = 0
    y_step = 0

    x_step = step_converter(x_delta)
    y_step = step_converter(y_delta)

    # puts "head: #{point.x}, #{point.y}, knot-#{name}: #{x}, #{y}, diff: #{x_delta}, #{y_delta}, move: #{x_step}, #{y_step}"

    move_by(x_step, y_step)

    save_history!
  end

  def save_history!
    # puts "#{@name}: [#{x}, #{y}]"
    @history << [x, y]
  end

  def diff(point)
    [point.x - x, point.y - y]
  end

  private

  def need_to_follow?(point)
    diff(point).any? { |i| i.abs > 1 }
  end

  def step_converter(delta)
    return 0 if delta.zero?

    delta > 0 ? 1 : -1
  end
end

class Roper
  attr_reader :instructions, :knots

  def initialize(instructions, knot_count: 2)
    @instructions = instructions
    # pp make_knots(knot_count)
    @knots = make_knots(knot_count)
  end

  def head
    @knots.first
  end

  def tail
    @knots.last
  end

  def run!
    instructions.map { |i| parse_instruction(i) }.each do |delta|
      head.move_by(*delta)
    end
  end

  private

  def make_knots(size)
    raise "not enough knots: #{size}" unless size > 1

    knots = []

    last_knot = nil

    size.times do |i|
      knots << Point.new(0, 0, name: i, tail: knots.last)
      # pp knots
    end

    knots.reverse
  end

  def parse_instruction(i)
    direction, distance = i.split
    distance = distance.to_i

    base_coords = case direction
                  when 'R'
                    [1, 0]
                  when 'L'
                    [-1, 0]
                  when 'U'
                    [0, 1]
                  when 'D'
                    [0, -1]
                  end

    base_coords.map { |i| i * distance }.tap do |x|
    end
  end
end

def solve_it(input, knots=2)
  roper = Roper.new(input, knot_count: knots)
  puts roper.knots.count
  roper.run!
  # pp roper.tail.history.uniq
  # pp roper.history
  roper.tail.history.uniq.count
end

test_output = solve_it(test_input.split("\n"))

if test_output == 13
  puts "TEST PASSED"
else
  puts "TEST FAILED #{test_output.inspect} != 13"
  abort
end

puts solve_it(File.readlines("./input"))

test_input2 = <<-T2
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
T2

test_output_2 = solve_it(test_input2.split("\n"), 10)

if test_output_2 == 36
  puts "TEST 2 PASSEd"
else
  puts "TEST FAILED #{test_output_2} != 36"
  abort
end

puts solve_it(File.readlines("./input"), 10)
