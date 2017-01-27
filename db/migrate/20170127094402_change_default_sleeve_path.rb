class ChangeDefaultSleevePath < ActiveRecord::Migration
  def change
    change_column_default :game_objects, :file_name, 'DefaultSleeve.png'
  end
end
