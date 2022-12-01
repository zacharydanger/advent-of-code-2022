class Elf
  attr_accessor :snacks

  def snacks
    @snacks ||= []
  end

  def snack_calories
    snacks.sum
  end
end

elf = Elf.new

elves = []

File.readlines('./input').each do |line|
  calories = line.to_i
  if calories > 0
    elf.snacks << calories
  else
    elves << elf
    elf = Elf.new
  end
end

elves.sort_by!(&:snack_calories)

puts "Most calories: #{elves.last.snack_calories}"
puts
puts "Top three: #{elves.last(3).sum(&:snack_calories)}"

