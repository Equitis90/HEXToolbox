# encoding: utf-8
require 'active_record'
require "open-uri"
require 'httparty'

class DbParse
  begin
    ActiveRecord::Base.establish_connection(
        adapter:  'postgresql',
        host:     'localhost',
        database: 'toolbox',
        username: ENV['RAILS_DB_ROLE'],
        password: ENV['RAILS_DB_PASS']
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
    count = 0
    uri = ''
    GameObject.all.each do | g_obj |
      g_obj.file_name = g_obj.file_name.gsub('.', '')
      g_obj.save!
      file_name = "#{File.dirname(__FILE__)}/assets/images/cards/en/#{g_obj.name.gsub( '\\', '' )}.png"
      unless File.exist?( file_name )
        uri = "http://cards.hex.gameforge.com/cardsdb/en/#{g_obj.name.gsub(/\[(.*)\]/, '')}.png"
        begin
          res = HTTParty.get( URI.encode( uri ) )
        rescue Exception => e
          puts uri
          puts count
          sleep( 2 )
          retry
        end
        if res.code.to_s == '200'
          puts "Writing #{g_obj.name}"
          File.open( file_name.chomp( '.png' ).gsub( '.', '' ) + '.png', 'wb') do | fo |
            fo.write( res.body )
          end
          g_obj.file_name = "#{g_obj.name.gsub( '\\', '' ).gsub( '.', '' )}"
          g_obj.save!
        end
        count += 1
      end
    end
    puts count
  rescue Exception => e
    puts e.message
  end
end
