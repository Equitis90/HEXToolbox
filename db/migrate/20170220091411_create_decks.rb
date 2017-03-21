class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.date :date
      t.string :ign
      t.string :tournament_id
      t.string :type
      t.string :name
      t.integer :points_won
      t.integer :wins
      t.integer :losses
      t.integer :champion_id

      t.timestamps null: false
    end
  end
end
