#!/usr/bin/env ruby

require 'sqlite3'

require_relative './voice.rb'

def escape(str)
  return "" if str.nil?

  str.gsub(/[\?\!\.,:\/"']/, "")  # remove special characters
end

if __FILE__ == $0

  OUTPUT_DIR = "#{SOUNDS_DIR}_renamed"

  `rm -rf "#{OUTPUT_DIR}"`
  `mkdir "#{OUTPUT_DIR}"`

  db = SQLite3::Database.new DB_FILENAME
  db.execute("select id, filename, hero, txt, info from voices order by id asc").each{|row|
    filename, hero, txt = row[1], row[2], row[3]

    filepath = File.join(SOUNDS_DIR, hero, "#{filename}.#{EXT}")
    renamed = File.join(OUTPUT_DIR, "#{hero}_#{escape(txt)}_#{filename}.#{EXT}")

    `cp "#{filepath}" "#{renamed}"`
  }

end
