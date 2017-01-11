class IndexController < ApplicationController
  def show
    @game_objects = GameObject.where( "object_type != 'Mod' AND object_type IS NOT NULL" ).order( :name ).page( params[ :page ] )
  end
end
