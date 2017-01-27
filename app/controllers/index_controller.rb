class IndexController < ApplicationController
  include SearchEngine

  def show
    search_query, req_params = search
    @game_objects = GameObject.where( search_query, req_params ).order( :name, :id, :set_number ).page( params[ :page ] ).per( 24 )
  end
end
