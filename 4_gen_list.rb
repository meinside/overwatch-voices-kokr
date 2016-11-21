#!/usr/bin/env ruby

require 'sqlite3'

require_relative './voice.rb'

HTML_FILENAME = "voices.html"

# Generates: a HTML file that can list and play sound files for each hero

if __FILE__ == $0

  lines = []

  lines << <<HEADER
<html>
  <header>
    <title>Overwatch Voices #{EXTRACTED_DATE}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/howler/2.0.1/howler.min.js"></script>
    <script type="text/javascript">
      function play(filepath) {
        var sound = new Howl({
          src: [filepath],
          autoplay: true,
          loop: false,
          volume: 1.0,
          onend: function() {
            console.log('Finished playing: ' + filepath);
          }
        });
      }
    </script>
    <style>
    body {
      color: #B0B0B0;
      background-color: #000000;
    }
    a {
      color: inherit;
      text-decoration: inherit;
    }
    div.anchors {
      color: #FFFFFF;
      font-size: 1.4em;
      margin: 4px;
    }
    div.hero {
      margin-top: 12px;
    }
    div.hero-name {
      color: #FFFFFF;
      font-size: 2.8em;
      font-weight: bold;
    }
    div.voice {
      margin: 4px;
    }
    span.hex {
      font-weight: bold;
      cursor: auto;
    }
    span.text {
      color: #FFFFFF;
      cursor: auto;
    }
    </style>
  </header>
  <body>
HEADER

  db = SQLite3::Database.new DB_FILENAME

  # get hero names
  heroes = []
  db.execute("select distinct hero from voices order by hero").each{|row|
    heroes << row[0]
  }

  lines << <<ANCHOR_HEADER
    <div class='anchors'>
ANCHOR_HEADER
  anchors = []
  heroes.each_with_index{|hero, i|
    anchors << "<a class='anchor' href='#hero#{i}'>#{hero}</a>"
  }
  lines << anchors.join(" | ")
  lines << <<ANCHOR_FOOTER
    </div>
ANCHOR_FOOTER

  # voices
  heroes.each_with_index{|hero, i|
    lines << <<HERO_HEADER
    <div class="hero" id="hero#{i}">
      <div class="hero-name">#{hero}</div>
HERO_HEADER

    db.execute("select id, filename, hero, txt, info from voices where hero = ? order by id asc", hero).each{|row|
      filename = row[1]
      txt = row[3]
      info = row[4]

      filepath = File.join(SOUNDS_DIR, hero, "#{filename}.#{EXT}")
      download_filename = "#{hero}_#{filename}_#{txt}.#{EXT}"

      lines << <<VOICE
      <div class="voice">
        <span class="hex"><a href="#{filepath}" download="#{download_filename}">#{filename}</a></span>: <span class="text" onclick="javascript:play('#{filepath}');">#{[txt, info].compact.join(" / ")}</span>
      </div>
VOICE
    }

    lines << <<HERO_FOOTER
    </div>
HERO_FOOTER
  }

  lines << <<FOOTER
  </body>
</html>
FOOTER

  # write to file
  File.open(HTML_FILENAME, 'w'){|file|
    file << lines.join("\n")
  }

end

