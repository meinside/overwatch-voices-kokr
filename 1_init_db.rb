#!/usr/bin/env ruby

require 'sqlite3'
require 'csv'

require_relative './voice.rb'

if __FILE__ == $0

  `rm -f '#{DB_FILENAME}' '#{CSV_FILENAME}'`

  ### sqlite
  #
  db = SQLite3::Database.new DB_FILENAME

  db.execute("create table if not exists voices(
          id integer primary key,
          filename text not null,
          hero text not null,
          txt text default null,
          info text default null
          )")
  db.execute("create index if not exists idx_voices1 on voices(filename)")
  db.execute("create index if not exists idx_voices2 on voices(hero)")
  db.execute("create index if not exists idx_voices3 on voices(hero, txt)")
  db.execute("create index if not exists idx_voices4 on voices(hero, txt, info)")
  db.execute("create index if not exists idx_voices5 on voices(hero, info)")

  # read file names
  voices = []
  Dir[File.join(SOUNDS_DIR, '*', '*.m4a')].each{|path|
    dirname = File.dirname(path)
    filename = File.basename(path)
    hex = File.basename(filename, ".*")

    voices << Voice.new(hex, dirname, nil, nil)
  }

  # sort by hex
  voices = voices.sort_by{|v| v.hex_number}

  # insert
  voices.each{|voice|
    db.execute("insert into voices(id, filename, hero, txt, info) values(?, ?, ?, ?, ?)",
               [voice.hex_number, voice.hex_string, voice.hero_name, voice.txt, voice.info])
  }

  # vacuum
  db.execute("vacuum")


  ### csv
  #
  CSV.open(CSV_FILENAME, 'wb'){|csv|
    csv << ['id', 'filename', 'hero', 'txt', 'info']

    voices.each{|voice|
      csv << [voice.hex_number, voice.hex_string, voice.hero_name, voice.txt, voice.info]
    }
  }

end

