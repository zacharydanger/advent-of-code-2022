class Trees
  attr_reader :trees

  def initialize(file)
    @file = file
    @trees = read_trees(file)
  end

  def output_file
    "#{@file}-output"
  end

  def visible_count
    count = 0

    trees.each_with_index { |row, y|
      row.each_with_index { |tree, x|
        visible = if (x - 1) < 0 || (x + 1) == row.size
                    true
                  elsif (y - 1) < 0 || (y + 1) == trees.size
                    true
                  elsif left_visible?(x, y) || right_visible?(x, y) || up_visible?(x,y) || down_visible?(x,y)
                    true
                  else
                    false
                  end

        count += 1 if visible
      }
    }

    count
  end

  def max_scenic_score
    map_scenic_scores!

    mapped.collect { |(x,y), t| t[:scenic][:total].to_i }.max
  end

  def map_scenic_scores!
    puts "mapping scenic scores..."
    mapped.each do |(x,y), tree|
      # puts "#{x},#{y}"
      tree[:scenic] = scenic_score(x,y)
    end
  end

  def max_x
    trees.first.count - 1
  end

  def max_y
    trees.count - 1
  end

  def mapped
    @mapped ||= begin
                  map = {}

                  trees.each_with_index do |row, y|
                    row.each_with_index do |height, x|
                      map[[x,y]] = { height: height, scenic: 0 }
                    end
                  end

                  map
                end

    @mapped.tap do |m|
      # m.each do |(x,y), tree|
        # if tree[:height] != trees[y][x]
          # puts "MAP INVALID: #{x},#{y} should be #{trees[y][x]}, got #{tree[:height]}"
          # abort
        # end
      # end
    end
  end

  def scenic_score(x,y)
    l = l_score(x,y)
    r = r_score(x,y)
    u = u_score(x,y)
    d = d_score(x,y)

    {
      total: l * r * u * d,
      left:  l,
      right: r,
      up:    u,
      down:  d
    }.tap do |ss|
      log_line = "#{x},#{y}: #{ss[:total]} (l:#{l}, r:#{r}, u:#{u}, d:#{d})\n"

      File.write(output_file, log_line, mode: 'a+')

      puts log_line
    end
  end

  def l_score(x,y)
    score = 0

    (0...x).to_a.reverse.each do |x2|
      score += 1
      break if mapped[[x2,y]][:height] >= mapped[[x,y]][:height]
    end

    score
  end

  def r_score(x,y)
    score = 0

    ((x+1)..max_x).each do |x2|
      score += 1
      break if mapped[[x2,y]][:height] >= mapped[[x,y]][:height]
    end

    score
  end

  def u_score(x,y)
    score = 0

    (0...y).to_a.reverse.each do |y2|
      score += 1
      break if mapped[[x,y2]][:height] >= mapped[[x,y]][:height]
    end

    score
  end

  def d_score(x,y)
    score = 0

    ((y+1)..max_y).to_a.each do |y2|
      score += 1
      break if mapped[[x,y2]][:height] >= mapped[[x,y]][:height]
    end

    score
  end

  def edge?(x,y)
    x == 0 || y == 0 || x == max_x || y == max_y
  end

  def read_trees(file)
    File.read(file).split("\n").map { |r| r.split('').map(&:to_i) }
  end

  def left_visible?(x, y)
    (0...x).all? { |x2|
      trees[y][x2] < trees[y][x]
    }
  end

  def right_visible?(x, y)
    ((x+1)...trees.first.size).all? { |x2|
      trees[y][x2] < trees[y][x]
    }
  end

  def up_visible?(x, y)
    (0...y).all? { |y2|
      trees[y2][x] < trees[y][x]
    }
  end

  def down_visible?(x, y)
    ((y+1)...trees.size).all? { |y2|
      trees[y2][x] < trees[y][x]
    }
  end
end


def solve(file)
  trees = Trees.new(file)
  # pp trees.trees
  trees.visible_count
end

def solve2(file)
  trees = Trees.new(file)
  trees.max_scenic_score
end

test_output = solve('./test_input')

test_scenic = solve2('./test_input')

if test_output == 21
  puts "TEST PASSED!"
else
  puts "TEST FAILED! Counted #{test_output}/21 trees."
  abort
end

if test_scenic == 8
  puts "SCENIC TEST PASSED!"
else
  puts "SCENIC TEST FAILED: EXPECTED 8, GOT #{test_scenic.inspect}"
  abort
end

# trees = Trees.new('./input')

# pp trees.mapped[[48,23]]
# pp trees.mapped[[48,24]]




puts "Real Count: #{solve('./input')}"

puts "Max Scenic Score: #{solve2('./input')}"
