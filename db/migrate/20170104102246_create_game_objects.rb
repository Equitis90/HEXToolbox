class CreateGameObjects < ActiveRecord::Migration
  def change
    create_table :game_objects do |t|
      t.integer :atk, null: false
      t.integer :cost, null: false
      t.string :name, null: false
      t.text :text, null: false
      t.text :type, null: false
      t.string :uuid, null: false
      t.text :color, null: false
      t.string :artist, null: false
      t.integer :health, null: false
      t.string :rarity, null: false
      t.string :faction, null: false
      t.string :sub_type, null: false
      t.text :threshold, null: false
      t.text :set_number, null: false
      t.integer :socket_count, null: false
      t.text :equipment_uuids, null: false

      t.timestamps null: false
    end
  end
end
