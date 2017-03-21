class CreateDeckGems < ActiveRecord::Migration
  def change
    create_table :deck_gems do |t|
      t.integer :card_id, null: false
      t.integer :gem_id, null: false
      t.references :deck, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
