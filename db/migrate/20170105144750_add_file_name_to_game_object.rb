class AddFileNameToGameObject < ActiveRecord::Migration
  def change
    add_column :game_objects, :file_name, :string, :default => 'DefaultSleeve', :null => false
  end
end
