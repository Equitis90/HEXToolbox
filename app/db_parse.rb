# encoding: utf-8
require 'active_record'
require "open-uri"
require "net/http"

class DbParse
  begin
    ActiveRecord::Base.establish_connection(
        adapter:  'postgresql',
        host:     'localhost',
        database: 'toolbox',
        username: 'toolbox',
        password: 'DkflbckfdCbljhtyrj'
    )

    class Object < ActiveRecord::Base

    end

    class GameObject < ActiveRecord::Base

    end
=begin
    ActiveRecord::Base.transaction do
      Object.all.each do | obj |
        GameObject.create!(
          atk: obj.data[ 'atk' ],
          cost: obj.data[ 'cost' ],
          name: obj.data[ 'name' ].gsub( '\', '' ),
          text: obj.data[ 'text' ],
          object_type: obj.data[ 'type' ].join( ', ' ),
          uuid: obj.data[ 'uuid' ],
          color: obj.data[ 'color' ].join( ', ' ),
          artist: obj.data[ 'artist' ],
          health: obj.data[ 'health' ],
          rarity: obj.data[ 'rarity' ],
          faction: obj.data[ 'faction' ],
          sub_type: obj.data[ 'sub_type' ],
          threshold: obj.data[ 'threshold' ].join( '<:>' ),
          set_number: obj.data[ 'set_number' ],
          socket_count: obj.data[ 'socket_count' ],
          equipment_uuids: obj.data[ 'equipment_uuids' ].join( ', ' )
        )
      end
    end
=end
    GameObject.all.each do | g_obj |
      url = URI.parse(URI.encode("http://cards.hex.gameforge.com/cardsdb/en/#{g_obj.name.gsub(/\[(.*)\]/, '')}.png") )
      req = Net::HTTP.new(url.host, url.port)
      res = req.request_head(url.path)
      if res.code == "200"
        if File.exist?("#{File.dirname(__FILE__)}/assets/images/#{g_obj.name.gsub( '\\', '' )}.png")
          g_obj.file_name = "#{g_obj.name.gsub( '\\', '' )}"
          g_obj.save!
        else
          File.open( "#{File.dirname(__FILE__)}/assets/images/#{g_obj.name.gsub( '\\', '' )}.png", 'wb') do |fo|
            fo.write open(URI.encode("http://cards.hex.gameforge.com/cardsdb/en/#{g_obj.name}.png") ).read
          end
          g_obj.file_name = "#{g_obj.name.gsub( '\\', '' )}"
          g_obj.save!
        end
      end
      puts "#{g_obj.name} processed"
    end
  rescue PG::Error => e
    puts e.message
  end
end