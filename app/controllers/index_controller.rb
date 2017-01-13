class IndexController < ApplicationController
  def show
    @sets = [
        {:name => 'Shards of Fate'},
        {:name => 'Shattered Destiny'},
        {:name => 'Primal Dawn'},
        {:name => 'Armies of Myth'},
        {:name => 'Herofall'}
    ]
    search_query = "object_type != 'Mod' AND object_type IS NOT NULL AND object_type != 'Equipment'"
    if params[ :set_selector ]
      search_query += " AND set_number in (#{params[ :set_selector ].map(&:inspect).join(', ').gsub(/\"/, '\'')})"
      @set_selector = params[ :set_selector ]
    end

    if params[ :scroll ]
      @scroll = true
    else
      @scroll = false
    end
    @game_objects = GameObject.where( search_query ).order( :name, :id, :set_number ).page( params[ :page ] ).per( 24 )
  end
end
