# encoding: utf-8
require 'active_record'
require "open-uri"
require 'httparty'
require 'json'

class DbParse
  ActiveRecord::Base.establish_connection(
    adapter:  'postgresql',
    host:     'localhost',
    database: 'toolbox',
    username: ENV['RAILS_DB_ROLE'],
    password: ENV['RAILS_DB_PASS']
  )

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

  def self.fileWrite( g_obj, file_name )
    if g_obj.file_name != file_name
      puts "Writing #{g_obj.name}"
      g_obj.file_name = file_name
      g_obj.save!
    end
  end
=begin
  card_array = []
  scars_file = File.open('/home/vlad/scars.txt')
  scars_file.each_line do |card|
    c = card.gsub("\n", '')
    card_array << c.split('|')
  end

  ActiveRecord::Base.transaction do
    card_array.each do | card |
      GameObject.create!(
        atk: card[ 10 ].to_i,
        cost: card[ 9 ].to_i,
        name: card[ 2 ].gsub( '\\', '' ),
        text: card[ 12 ].gsub('\\', ''),
        object_type: card[ 5 ],
        uuid: card[ 20 ],
        color: card[ 4 ] == '' ? 'Colorless' : card[ 4 ].gsub(/\d\s/, ''),
        artist: card[ 15 ],
        health: card[ 11 ].to_i,
        rarity: card[ 3 ],
        sub_type: card[ 6 ],
        threshold: card[ 4 ],
        set_number: card[ 0 ],
        equipment_uuids: card[ 17 ]
      )
    end
  end
=end
  count = 0

  GameObject.where(object_type: 'Equipment').each do | g_obj |
    if g_obj.file_name == 'DefaultSleeve.png'
      uri_equipment = "https://hex.tcgbrowser.com/images/equipment/#{g_obj.name.gsub(' ', '')}.jpg"
      uri = "https://hextcg.com/wp-content/themes/hex/images/autocard/#{g_obj.name.gsub(/\[(.*)\]/, '').gsub(':', '')}.png"
      uri_a = "https://hextcg.com/wp-content/themes/hex/images/autocard/#{g_obj.name.gsub(/\[(.*)\]/, '').gsub(':', '')} AA.png"
      champion_uri = "https://hextcg.com/wp-content/themes/hex/images/autocard/champions/#{g_obj.name.gsub(/\[(.*)\]/, '').gsub(':', '')}.png"

      if g_obj.object_type == 'Champion'
        res = netConnection( champion_uri, count )
      elsif g_obj.object_type == 'Equipment'
        res = netConnection( uri_equipment, count )
      else
        res = netConnection( uri, count )
      end

      if res.code.to_s == '200'
        if g_obj.object_type  == 'Champion'
          fileWrite( g_obj, champion_uri )
        elsif g_obj.object_type == 'Equipment'
          fileWrite(g_obj, uri_equipment)
        else
          if g_obj.rarity == 'Epic'
            res_a = netConnection( uri_a, count )
            if res_a.code.to_s == '200'
              fileWrite( g_obj, uri_a )
            else
              fileWrite( g_obj, uri )
            end
          else
            fileWrite( g_obj, uri )
          end
        end
      elsif res.code.to_s == '404' && g_obj.rarity == 'Epic' && g_obj.object_type != 'Equipment'
        res_a = netConnection( uri_a, count )
        if res_a.code.to_s == '200'
          fileWrite( g_obj, uri_a )
        end
      elsif res.code.to_s == '404' && g_obj.object_type == 'Equipment'
        fileWrite( g_obj, 'DefaultEquipment.png' )
      end
      count += 1
    end
  end
  puts count
end
