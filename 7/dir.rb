def unfuck_it(file)
  files = {}

  dir_sizes = {}

  current_dir = nil

  File.readlines(file).each do |line|
    line.strip!
    if line.start_with? '$'
      _sh, command, arg = line.split(' ')

      puts "COMMAND: #{command} #{arg}"

      if command == 'cd'
        if arg == '/'
          current_dir = ['root']
        elsif arg == '..'
          current_dir.pop
        else
          current_dir << arg
        end

        puts "current_dir: #{current_dir.join('/') || '/'}"
      end
    elsif line.start_with? /\d/
      puts "FILE: #{line}"
      size, name = line.split(' ')

      file_name = (current_dir + [name]).join('/')

      files[file_name] = size.to_i
    else
      puts "OUTPUT:  #{line}"
    end
  end

  files
end

fs = 70000000
rs = 30000000

files = unfuck_it('./input')

pp files

used_space = files.values.sum

free_space = fs - used_space

need_to_free = rs - free_space

puts "Used Space: #{used_space}"
puts "Free Space: #{free_space}"
puts "Needed:     #{rs - free_space}"

dirs = files.keys.map do |fpath|
  fpath.split('/').tap do |f|
    f.pop
  end.join('/')
end

dir_totes = {}

dirs.each do |dir|
  dir_totes[dir] = files.select { |k,v|
    k.start_with? dir
  }.values.sum
end

dir_totes.select! { |k,v|
 v >= need_to_free
}

pp dir_totes.values.sort.first
