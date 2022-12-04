def solve_it(file)
  File.readlines(file).inject(0) do |count, line|
    ranges = line.strip.split(',')

    ranges = ranges.map! { |r|
      first,last = r.split('-').map(&:to_i)

      (first..last).to_a.uniq
    }

    if ((ranges[0] & ranges[1]) == ranges[0]) || ((ranges[0] & ranges[1]) == ranges[1])
      count + 1
    else
      count
    end
  end
end

test_result = solve_it './test_input'

if 2 == test_result
  puts "It works!"
else
  puts "Shit's fucked, expected 2 got: #{test_result.inspect}"
end

puts "Final Count: #{solve_it('./input')}"

def solve_it_again(file)
  File.readlines(file).inject(0) do |count, line|
    ranges = line.strip.split(',')

    ranges = ranges.map! { |r|
      first,last = r.split('-').map(&:to_i)

      (first..last).to_a
    }

    (ranges[0] & ranges[1]).any? ? count + 1 : count
  end
end

test_result = solve_it_again './test_input'

if 4 == test_result
  puts "It works again!"
else
  puts "Shit's fucked again, expected 4 got: #{test_result.inspect}"
end

puts "Final Count (again): #{solve_it_again './input'}"
