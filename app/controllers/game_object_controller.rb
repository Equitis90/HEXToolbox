class GameObjectController < ApplicationController
  def show
    @card = GameObject.where( id: params[ :id ] ).first
    @equipments = {}
    if @card.equipment_uuids != ''
      GameObject.where( uuid: @card.equipment_uuids.split( ', ' ) ).each do | equipment |
        @equipments[ equipment.uuid ] = {
          name: equipment.name,
          file_name: equipment.file_name,
          text: equipment.text.gsub('#VAR1_1#', '1')
            .gsub(/\[([\(0-9\)]+|[A-Z\-^\]]+|[L0-9\]\[R0-9]+)\]/, '<span class=\0></span>')
            .gsub( '#SELF#', @card.name ).gsub('#IGNORE_CHAIN#', ''),
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
