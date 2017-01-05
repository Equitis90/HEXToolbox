class ChangeGameObject < ActiveRecord::Migration
  def change
    rename_column :game_objects, :type, :object_type
    change_column :game_objects, :cost, :integer, :null => true
  end
end
