class IndexController < ApplicationController
  include SearchEngine

  def show
    search_query, req_params = search
    @game_objects = GameObject.where( search_query, req_params ).order( :name, :id, :set_number ).page( params[ :page ] ).per( 24 )
    @image_urls = {}
    @game_objects.each do | g_obj |
      if g_obj.file_name == 'DefaultSleeve'
        @image_urls[ g_obj.id ] = 'DefaultSleeve.png'
      else
        if g_obj.file_name  =~ /AA/
          @image_urls[ g_obj.id ] = "http://cards.hex.gameforge.com/cardsdb/en/#{g_obj.name.gsub(/\[(.*)\]/, '')} AA.png"
        else
          @image_urls[ g_obj.id ] = "http://cards.hex.gameforge.com/cardsdb/en/#{g_obj.name.gsub(/\[(.*)\]/, '')}.png"
        end
      end
    end
  end
end
