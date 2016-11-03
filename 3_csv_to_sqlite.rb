#!/usr/bin/env ruby

require 'csv'
require 'sqlite3'

require_relative './voice.rb'

if __FILE__ == $0

  `rm -f "#{DB_FILENAME}"`

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

  CSV.read(CSV_FILENAME)[1..-1].each{|row|  # XXX - skip header
    id = row[0]
    filename = row[1]
    hero = row[2]
    txt = row[3]
    info = row[4]

    db.execute("insert into voices(id, filename, hero, txt, info) values(?, ?, ?, ?, ?)", [id, filename, hero, txt, info])
  }

end
