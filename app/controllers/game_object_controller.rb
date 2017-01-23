class GameObjectController < ApplicationController
  def show
    @card = GameObject.where( id: params[ :id ]).first
    @equipments = {}
    if @card.equipment_uuids != ''
      GameObject.where( uuid: @card.equipment_uuids.split( ', ' ) ).each do | g_obj |
        @equipments[ g_obj.uuid ] = { name: g_obj.name, file_name: g_obj.file_name }
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
end
