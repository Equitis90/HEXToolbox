class GameObjectController < ApplicationController
  def show
    @card = GameObject.where( id: params[ :id ] ).first
    @equipments = {}
    if @card.equipment_uuids != ''
      GameObject.where( uuid: @card.equipment_uuids.split( ', ' ) ).each do | equipment |
        @equipments[ equipment.uuid ] = {
            name: equipment.name,
            file_name: equipment.file_name,
            text: equipment.text,
            slot: equipment.sub_type
        }
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
end
