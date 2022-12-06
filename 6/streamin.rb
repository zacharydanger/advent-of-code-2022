# The device will send your subroutine a datastream buffer (your puzzle input); your subroutine needs to identify the first position where the four most recently received characters were all different. Specifically, it needs to report the number of characters from the beginning of the buffer to the end of the first such four-character marker.

# For example, suppose you receive the following datastream buffer:

# mjqjpqmgbljsphdztnvjfqwrcgsmlb

# After the first three characters (mjq) have been received, there haven't been enough characters received yet to find the marker. The first time a marker could occur is after the fourth character is received, making the most recent four characters mjqj. Because j is repeated, this isn't a marker.

# The first time a marker appears is after the seventh character arrives. Once it does, the last four characters received are jpqm, which are all different. In this case, your subroutine should report the value 7, because the first start-of-packet marker is complete after 7 characters have been processed.

# Here are a few more examples:

    # bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 5
    # nppdvjthqldpwncqszvftbrmjlhg: first marker after character 6
    # nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 10
    # zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 11

# How many characters need to be processed before the first start-of-packet marker is detected?

def packet_posish(stream)
  pos    = 0
  count  = 4
  stream = stream.split('')

  while piece = stream.slice(pos, count)
    if uniq?(piece)
      return pos + 4
    else
      pos += 1
    end
  end
end

def uniq?(array)
  array.uniq.count == array.count
end

tests = {
    "bvwbjplbgvbhsrlpgdmjqwftvncz"      => 5,
    "nppdvjthqldpwncqszvftbrmjlhg"      => 6,
    "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg" => 10,
    "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"  => 11
}

puts "Running tests..."

tests.each do |k,v|
  output = packet_posish(k)
  if output == v
    puts "#{k} => #{v} PASS"
  else
    puts "#{k} => #{v} FAIL, GOT #{output.inspect}"
    abort
  end
end

input = File.read('./input')

puts "ACTUAL: #{packet_posish(input)}"
