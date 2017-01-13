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

    def self.netConnection( uri, count )
      begin
        res = HTTParty.get( URI.encode( uri ) )
      rescue Exception => e
        puts uri
        puts count
        sleep( 2 )
        retry
      end
    end

    def self.fileWrite( g_obj, file_name, res, aa = '' )
      puts "Writing #{g_obj.name}#{aa}"
      File.open( file_name, 'wb' ) do | fo |
        fo.write( res.body )
      end
      g_obj.file_name = "#{g_obj.name.gsub( '\\', '' ).gsub( '.', '' )}#{aa}"
      g_obj.save!
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
    #GameObject.update_all( file_name: 'DefaultSleeve' )

    GameObject.all.each do | g_obj |
      file_name = "#{File.dirname(__FILE__)}/assets/images/cards/en/#{g_obj.name.gsub( '\\', '' ).gsub( '.', '' )}.png"
      file_name_a = "#{File.dirname(__FILE__)}/assets/images/cards/en/#{g_obj.name.gsub( '\\', '' ).gsub( '.', '' )} AA.png"
      uri = "http://cards.hex.gameforge.com/cardsdb/en/#{g_obj.name.gsub(/\[(.*)\]/, '')}.png"
      uri_a = "http://cards.hex.gameforge.com/cardsdb/en/#{g_obj.name.gsub(/\[(.*)\]/, '')} AA.png"

      res = netConnection( uri, count )

      if res.code.to_s == '200'
        if File.exist?( file_name )
          if g_obj.rarity == 'Epic'
            if File.exist?( file_name_a )
              g_obj.file_name = "#{g_obj.name.gsub( '\\', '' ).gsub( '.', '' )} AA"
              g_obj.save!
            else
              res_a = netConnection( uri_a, count )
              if res_a.code.to_s == '200'
                fileWrite( g_obj, file_name_a, res_a, ' AA')
              end
            end
          else
            g_obj.file_name = "#{g_obj.name.gsub( '\\', '' ).gsub( '.', '' )}"
            g_obj.save!
          end
        elsif File.exist?( file_name_a ) && g_obj.rarity == 'Epic'
          g_obj.file_name = "#{g_obj.name.gsub( '\\', '' ).gsub( '.', '' )} AA"
          g_obj.save!
        else
          if g_obj.rarity == 'Epic'
            res_a = netConnection( uri_a, count )
            if res_a.code.to_s == '200'
              fileWrite( g_obj, file_name_a, res_a, ' AA')
            end
          else
            fileWrite( g_obj, file_name, res)
          end
        end
      elsif res.code.to_s == '404' && g_obj.rarity == 'Epic'
        res_a = netConnection( uri_a, count )
        if res_a.code.to_s == '200'
          if File.exist?( file_name_a )
            g_obj.file_name = "#{g_obj.name.gsub( '\\', '' ).gsub( '.', '' )} AA"
            g_obj.save!
          else
            fileWrite( g_obj, file_name_a, res_a, ' AA')
          end
        end
      end
      count += 1
    end
    puts count
  rescue Exception => e
    puts e.message
  end
end
