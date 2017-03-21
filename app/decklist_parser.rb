# encoding: utf-8
require "open-uri"
require 'httparty'
require 'active_record'

class DecklistParser
  ActiveRecord::Base.establish_connection(
      adapter:  'postgresql',
      host:     'localhost',
      database: 'toolbox',
      username: ENV['RAILS_DB_ROLE'],
      password: ENV['RAILS_DB_PASS']
  )

  class GameObject < ActiveRecord::Base

  end

  class Deck < ActiveRecord::Base

  end

  class DeckCard < ActiveRecord::Base

  end

  class DeckGem < ActiveRecord::Base

  end

  class ProcessedFile < ActiveRecord::Base

  end

  def self.netConnection( uri )
    begin
      res = HTTParty.get( URI.encode( uri ) )
    rescue Exception => e
      puts uri
      sleep( 2 )
      retry
    end
  end

  def self.writeDeck( decks, date, name, tournament_id, tournament_type, player, results, champion, deck, reserves, gems )
    decks << {
      date: date,
      name: name,
      tornament_id: tournament_id,
      type: tournament_type,
      player: player,
      points_won: results[ 0 ],
      wins: results[ 1 ],
      losses: results[ 2 ],
      champion: champion,
      deck: deck,
      reserves: reserves,
      gems: gems
    }
  end
  uri_list = 'http://dl.hex.gameforge.com/decklist/index.txt'

  res = netConnection( uri_list )
  decks = []
  if res.code.to_s == '200'
    res.body.each_line do | line |
      file_name = line.gsub( "\n", '' )
      res_file = netConnection( "http://dl.hex.gameforge.com/decklist/#{file_name}" )
      new_tournament = false
      date = nil
      name = nil
      tournament_id = nil
      deck_end = false
      player = nil
      results = nil
      champion = nil
      decklist = nil
      if res_file.code.to_s == '200'
        tournament_type = line.scan(/Decklist-Data-(.*)-.*.ddf/)[ 0 ][ 0 ]
        deck = {}
        reserves = {}
        gems = []
        to_deck = false
        res_file.body.each_line do | file_line |
          pluralized_line = file_line.gsub( "\n", '' )
          if pluralized_line == '-=================================================================================================================================================================-'
            new_tournament = true
            next
          end
          if pluralized_line.index(/Tournament .*/)
            new_tournament = true
            if deck_end
              writeDeck( decks, date, name, tournament_id, tournament_type, player, results, champion, deck, reserves, gems )
              deck = {}
              reserves = {}
              gems = []
              deck_end = false
            end
          end
          if new_tournament
            tournament_data = pluralized_line.split( ' - ' )
            date = tournament_data[ 0 ].split( ' ', 2 )[ 0 ].gsub( '-', '' )
            if tournament_data.size == 3
              name = tournament_data[ 2 ] ? tournament_data[ 2 ].gsub( ' :', '' ) : ''
              tournament_id = tournament_data[ 1 ].gsub( 'Tournament ', '' ).gsub( ':', '' )
            elsif tournament_data.size == 2
              name = tournament_data[ 1 ]
              tournament_id = ''
            else
              name = ''
              tournament_id = tournament_data[ 0 ].split( ' ', 2 )[ 1 ]
              date = ''
            end
            new_tournament = false
          end
          if pluralized_line.index(/Player:/)
            player = pluralized_line.gsub(/Player:/, '').gsub(/[[:space:]]/, '')
          end
          if pluralized_line.index('Points won:')
            results = pluralized_line.gsub("\t", '').gsub(' ', '').scan(/Pointswon:(\d*)Wins\/Losses:(\d*)\/(\d*)/)[ 0 ]
          end
          if pluralized_line.index('Champion:')
            champion = pluralized_line.gsub("\t", '').scan(/Champion:[[:space:]]*\[card\](.*)\[\/card\]|NULL/)[ 0 ][ 0 ]
          end
          if pluralized_line == '[decklist]'
            decklist = true
          end
          if pluralized_line == '[Deck]'
            to_deck = true
          end
          if pluralized_line == '[Reserves]'
            to_deck = false
          end
          if pluralized_line == '[/decklist]'
            deck_end = true
            decklist = false
          end
          if pluralized_line.index(/\d/) && decklist
            card_info = pluralized_line.gsub("\t", '').gsub(' ', '').scan(/(\d*)(.*)/)[ 0 ]
            if to_deck
              deck[ card_info[ 1 ] ] = card_info[ 0 ]
            else
              reserves[ card_info[ 1 ] ] = card_info[ 0 ]
            end
          end
          if pluralized_line.index('socketed with')
            gems_ar = pluralized_line.gsub("\t", '').scan(/(.*)[[:space:]]*socketed with[[:space:]]*\[card\](.*)\[\/card\]/)[ 0 ]
            unless gems_ar.nil?
              gems_ar[1].split('[/card] [card]').each do | gem_name |
                gems << { card_name: gems_ar[0].rstrip, gem_name: gem_name }
              end
            end
          end
          if pluralized_line == '<hr>' && deck_end
            writeDeck( decks, date, name, tournament_id, tournament_type, player, results, champion, deck, reserves, gems )
            deck = {}
            reserves = {}
            gems = []
            deck_end = false
          end
        end
        unless res_file.body.empty?
          writeDeck( decks, date, name, tournament_id, tournament_type, player, results, champion, deck, reserves, gems )
          deck = {}
          reserves = {}
          gems = []
        end
      end
    end
  end
  puts decks.size
end