class EquipmentController < ApplicationController
  include SearchEngine

  def list
    equipments_query = "object_type = 'Equipment'"
    search_query, req_params = search
    search_query = equipments_query + search_query
    @equipments = GameObject.where( search_query, req_params ).order( :name, :id, :set_number ).page( params[ :page ] ).per( 24 )
  end
  respond_to do |format|
    format.html
    format.js
  end
end
