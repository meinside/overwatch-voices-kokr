#!/usr/bin/env ruby

require 'csv'
require 'sqlite3'

require_relative './voice.rb'

if __FILE__ == $0

  db = SQLite3::Database.new DB_FILENAME

  CSV.open(CSV_FILENAME, 'wb'){|csv|
    csv << ['id', 'filename', 'hero', 'txt', 'info']

    db.execute("select id, filename, hero, txt, info from voices order by id asc").each{|row|
      csv << row
    }
  }

end
