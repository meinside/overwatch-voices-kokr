#!/usr/bin/env ruby

require_relative './voice.rb'

if __FILE__ == $0

  # XXX - so many duplicated files in these directories!
  check_targets = [
    '좀닉 포병',
    '충격 타이어',
    '훈련용 봇',
  ]

  dirs = Dir[File.join(SOUNDS_DIR, '*')]
  check_targets.each{|t|
    dirs.delete File.join(SOUNDS_DIR, t)
  }

  puts "Checking #{dirs.count} directories..."

  counts = {}
  dirs.each{|dir|
    puts "Checking directory: #{dir}"

    Dir[File.join(dir, '*')].each{|file|
      filename = File.basename(file)
      if counts.has_key? filename
        counts[filename] += 1
      else
        counts[filename] = 1
      end
    }
  }

  dup = {}
  check_targets.each{|t|
    dir = File.join(SOUNDS_DIR, t)
    dup[dir] = []

    Dir[File.join(dir, '*')].each{|file|
      filename = file.split('/')[-1]
      if counts.has_key? filename
        dup[dir] << filename
      end
    }
  }

  # show result
  dup.each{|k, v|
    puts "Duplicated #{v.count} file(s) in '#{k}' will be deleted."
    v.each{|filepath|
      `rm "#{File.join(k, filepath)}"`
    }
  }

end

