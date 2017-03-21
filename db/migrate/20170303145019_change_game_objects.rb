class ChangeGameObjects < ActiveRecord::Migration
  def change
    remove_column :game_objects, :socket_count
    remove_column :game_objects, :faction
    rename_column :processed_files, :fie_name, :file_name
  end
end
