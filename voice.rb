#!/usr/bin/env ruby

# last update (when .wem files were extracted)
EXTRACTED_DATE = '20161215'

SOUNDS_DIR = 'sounds'

DB_FILENAME = "voices_#{EXTRACTED_DATE}.sqlite"
CSV_FILENAME = "voices_#{EXTRACTED_DATE}.csv"

EXT = 'm4a'

class Voice
  attr_accessor :hex_string, :hex_number, :hero_name, :txt, :info

  def initialize(hex_string, hero_name, txt = nil, info = nil)
    @hex_string = hex_string
    @hex_number = Integer(hex_string, 16)
    @hero_name = hero_name
    @txt = txt
    @info = info
  end
end
