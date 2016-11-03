#!/usr/bin/env ruby

require 'sqlite3'

require_relative './voice.rb'

PLAY_REPEAT = 2

if __FILE__ == $0

  arg = []
  if ARGV.length > 0
    db = SQLite3::Database.new DB_FILENAME

    STDOUT.sync = true

    db.execute("select id, filename, hero from voices where (txt is null or txt = '' or txt = '?') and hero = ?", ARGV[0]).each{|row|
      id = row[0]
      filename = "#{row[1]}.#{EXT}"
      hero = row[2]

      filepath = File.join(SOUNDS_DIR, hero, filename)

      # play sound and input text
      print "Playing: #{filepath} "
      PLAY_REPEAT.times {
        print '.'
        `afplay '#{filepath}'`  # XXX - OSX only
      }
      print "input text: "

      txt = STDIN.gets.chomp
      if txt.length > 0
        db.execute('update voices set txt = ? where id = ?', [txt, id])
      end
    }
  else
    puts "* Usage: #{__FILE__} HERO_NAME"
  end

end

