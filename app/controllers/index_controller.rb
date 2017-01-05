class IndexController < ApplicationController
  def show
    @game_objects = GameObject.where( "object_type != 'Champion' AND object_type != 'Mod' AND object_type IS NOT NULL" ).limit( 50 )
  end
end
