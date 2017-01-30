module SearchEngine
  def search()
    @sets = [
        { :name => 'Shards of Fate' },
        { :name => 'Shattered Destiny' },
        { :name => 'Primal Dawn' },
        { :name => 'Armies of Myth' },
        { :name => 'Herofall' },
        { :name => 'Set01_PvE_Arena' },
        { :name => 'AZ1' },
        { :name => 'PvE_AZ1_Created_Effects' },
        { :name => 'AZ2' },
        { :name => 'PvE_AZ2_Created_Effects' },
        { :name => 'Set03_PvE_Promo' },
        { :name => 'Set04_PvE_Promo' },
        { :name => 'Set05_PvE_Promo' },
        { :name => 'Engineering_Oddities' }
    ]
    @types = [
        { :name => 'Constant, Quick' },
        { :name => 'Artifact' },
        { :name => 'Resource' },
        { :name => 'Quick, Troop' },
        { :name => 'Basic Action' },
        { :name => 'Constant' },
        { :name => 'Troop' },
        { :name => 'Quick Action' },
        { :name => 'Bane' },
        { :name => 'Artifact, Troop' }
    ]
    @shards = [
        { :name => 'Diamond', :data_img => ActionController::Base.helpers.asset_path('Diamond.png') },
        { :name => 'Ruby', :data_img => ActionController::Base.helpers.asset_path('Ruby.png') },
        { :name => 'Sapphire', :data_img => ActionController::Base.helpers.asset_path('Sapphire.png') },
        { :name => 'Wild', :data_img => ActionController::Base.helpers.asset_path('Wild.png') },
        { :name => 'Blood', :data_img => ActionController::Base.helpers.asset_path('Blood.png') }
    ]
    @rarities = [
        { :name => 'Common' },
        { :name => 'Uncommon' },
        { :name => 'Rare' },
        { :name => 'Legendary' },
        { :name => 'Epic' },
        { :name => 'Promo' }
    ]
    @slots = GameObject.select( :sub_type ).distinct.where( object_type: 'Equipment' ).order( :sub_type )
       .map { |g_obj| { :name => g_obj.sub_type } }
    @costs = GameObject.select( :cost ).distinct.where.not( :cost => nil )
      .order( :cost ).map { |g_obj| { :name => g_obj.cost } }
    @sub_types = GameObject.select( :sub_type ).distinct.where.not( :sub_type => [ nil, '' ],
      :object_type => [ nil, 'Mersenary', 'Champion', 'Equipment', 'Mod' ] )
      .order( :sub_type ).map { |g_obj| { :name => g_obj.sub_type } }

    search_query = ''
    req_params = {}
    if params[ :pvp_only_selector ]
      @pvp_only_selector = true
      if params[ :set_selector ].nil?
        search_query += " AND set_number NOT IN('Set01_PvE_Arena', 'AZ1', 'PvE_AZ1_Created_Effects', 'AZ2', 'PvE_AZ2_Created_Effects', 'Set03_PvE_Promo', 'Set04_PvE_Promo', 'Set05_PvE_Promo', 'Engineering_Oddities')"
      end
    end
    if params[ :set_selector ]
      if @pvp_only_selector
        params[ :set_selector ].each do | set |
          if set.in?(%w'Set01_PvE_Arena AZ1 PvE_AZ1_Created_Effects AZ2 PvE_AZ2_Created_Effects Set03_PvE_Promo Set04_PvE_Promo Set05_PvE_Promo Engineering_Oddities')
            params[ :set_selector ] -= set
          end
        end
      end
      if params[ :set_selector ].empty?
        search_query += " AND set_number NOT IN('Set01_PvE_Arena', 'AZ1', 'PvE_AZ1_Created_Effects', 'AZ2', 'PvE_AZ2_Created_Effects', 'Set03_PvE_Promo', 'Set04_PvE_Promo', 'Set05_PvE_Promo', 'Engineering_Oddities')"
      else
        if params[ :set_selector ].size == 1
          search_query += ' AND set_number = :set_selector'
        else
          search_query += ' AND set_number IN (:set_selector)'
        end
        @set_selector = params[ :set_selector ]
        req_params[:set_selector] = params[ :set_selector ]
      end
    end
    if params[ :type_selector ]
      if params[ :type_selector ].size == 1
        search_query += ' AND object_type = :type_selector'
      else
        search_query += ' AND object_type IN (:type_selector)'
      end
      @type_selector = params[ :type_selector ]
      req_params[:type_selector] = params[ :type_selector ]
    end
    unless params[ :card_name ].blank?
      search_query += ' AND name LIKE :card_name'
      @card_name = params[ :card_name ]
      req_params[:card_name] = "#{params[ :card_name ]}%"
    end
    if params[ :cost_selector ]
      if params[ :cost_selector ].size == 1
        search_query += ' AND cost = :cost_selector'
      else
        search_query += ' AND cost IN (:cost_selector)'
      end
      @cost_selector = params[ :cost_selector ]
      req_params[:cost_selector] = params[ :cost_selector ]
    end
    if params[ :sub_type_selector ]
      if params[ :sub_type_selector ].size == 1
        search_query += ' AND sub_type = :sub_type_selector'
      else
        search_query += ' AND sub_type IN (:sub_type_selector)'
      end
      @sub_type_selector = params[ :sub_type_selector ]
      req_params[:sub_type_selector] = params[ :sub_type_selector ]
    end
    if params[ :shard_selector ]
      if params[ :shard_selector ].size == 1
        search_query += ' AND color LIKE :shard_selector'
      else
        search_query += ' AND color LIKE ANY (ARRAY[:shard_selector])'
      end
      @shard_selector = params[ :shard_selector ]
      req_params[:shard_selector] = params[ :shard_selector ].map { | shard | "%#{shard}%" }
    end
    if params[ :rarity_selector ]
      if params[ :rarity_selector ].size == 1
        search_query += ' AND rarity = :rarity_selector'
      else
        search_query += ' AND rarity IN (:rarity_selector)'
      end
      @rarity_selector = params[ :rarity_selector ]
      req_params[:rarity_selector] = params[ :rarity_selector ]
    end
    if params[ :scroll ]
      @scroll = true
    end
    return search_query, req_params
  end
end