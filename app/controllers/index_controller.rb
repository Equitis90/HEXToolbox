class IndexController < ApplicationController
  def show
    @sets = [
        { :name => 'Shards of Fate' },
        { :name => 'Shattered Destiny' },
        { :name => 'Primal Dawn' },
        { :name => 'Armies of Myth' },
        { :name => 'Herofall' }
    ]
    @types = [
        { :name => 'Constant, Quick' },
        { :name => 'Artifact' },
        { :name => 'Resource' },
        { :name => 'Quick, Troop' },
        { :name => 'Basic Action' },
        { :name => 'Constant' },
        { :troop => 'Troop' },
        { :name => 'Quick Action' },
        { :name => 'Bane' },
        { :name => 'Artifact, Troop' }
    ]
    @costs = GameObject.select( :cost ).distinct.where.not( :cost => nil )
      .order( :cost ).map { |g_obj| { :name => g_obj.cost } }
    @sub_types = GameObject.select( :sub_type ).distinct.where.not( :sub_type => [ nil, '' ],
      :object_type => [ nil, 'Mersenary', 'Champion', 'Equipment', 'Mod' ] )
      .order( :sub_type ).map { |g_obj| { :name => g_obj.sub_type } }
    search_query = "(NOT (object_type IN ('Mod', 'Mersenary', 'Champion', 'Equipment') OR object_type IS NULL))"
    req_params = {}
    if params[ :set_selector ]
      if params[ :set_selector ].size == 1
        search_query += " AND set_number = :set_selector"
      else
        search_query += " AND set_number in (:set_selector)"
      end
      @set_selector = params[ :set_selector ]
      req_params[:set_selector] = params[ :set_selector ]
    end
    if params[ :type_selector ]
      if params[ :type_selector ].size == 1
        search_query += " AND object_type = :type_selector"
      else
        search_query += " AND object_type in (:type_selector)"
      end
      @type_selector = params[ :type_selector ]
      req_params[:type_selector] = params[ :type_selector ]
    end
    unless params[ :card_name ].blank?
      search_query += " AND name like :card_name"
      @card_name = params[ :card_name ]
      req_params[:card_name] = "#{params[ :card_name ]}%"
    end
    if params[ :cost_selector ]
      if params[ :cost_selector ].size == 1
        search_query += " AND cost = :cost_selector"
      else
        search_query += " AND cost in (:cost_selector)"
      end
      @cost_selector = params[ :cost_selector ]
      req_params[:cost_selector] = params[ :cost_selector ]
    end
    if params[ :sub_type_selector ]
      if params[ :sub_type_selector ].size == 1
        search_query += " AND sub_type = :sub_type_selector"
      else
        search_query += " AND sub_type in (:sub_type_selector)"
      end
      @sub_type_selector = params[ :sub_type_selector ]
      req_params[:sub_type_selector] = params[ :sub_type_selector ]
    end
    if params[ :scroll ]
      @scroll = true
    end

    @game_objects = GameObject.where( search_query, req_params ).order( :name, :id, :set_number ).page( params[ :page ] ).per( 24 )
  end
end
