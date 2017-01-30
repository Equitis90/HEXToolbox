class IndexController < ApplicationController
  include SearchEngine

  def show
    cards_query = "(NOT (object_type IN ('Mod', 'Mercenary', 'Champion', 'Equipment') OR set_number IN ('UNSET', 'AI Only Cards', 'None_Defined'))) AND rarity != 'Non-Collectible' AND object_type IS NOT NULL AND object_type != ''"
    search_query, req_params = search
    search_query = cards_query + search_query
    @game_objects = GameObject.where( search_query, req_params ).order( :name, :id, :set_number ).page( params[ :page ] ).per( 24 )
  end
  respond_to do |format|
    format.html
    format.js
  end
end
