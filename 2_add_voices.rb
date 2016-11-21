#!/usr/bin/env ruby

require 'sqlite3'

require_relative './voice.rb'

if __FILE__ == $0

  # read file names
  voices = []
  Dir[File.join(SOUNDS_DIR, '*', '*.m4a')].each{|path|
    dirname = File.basename(File.dirname(path))
    filename = File.basename(path)
    hex = File.basename(filename, ".*")

    voices << Voice.new(hex, dirname, nil, nil)
  }

  # sort by hex
  voices = voices.sort_by{|v| v.hex_number}

  db = SQLite3::Database.new DB_FILENAME

  # insert
  num_duplicated = 0
  voices.each{|voice|
    begin
      db.execute("insert into voices(id, filename, hero, txt, info) values(?, ?, ?, ?, ?)",
                 [voice.hex_number, voice.hex_string, voice.hero_name, voice.txt, voice.info])
    rescue SQLite3::ConstraintException
      num_duplicated += 1
    end
  }

  # vacuum
  db.execute("vacuum")

  puts "Newly inserted: #{voices.count - num_duplicated} file(s), already exist: #{num_duplicated} file(s)"

end

