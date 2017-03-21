class CreateDeckCards < ActiveRecord::Migration
  def change
    create_table :deck_cards do |t|
      t.integer :amount, null: false
      t.integer :card_id, null: false
      t.references :deck, index: true, foreign_key: true, null: false
      t.boolean :reserve, default: false, null: false

      t.timestamps null: false
    end
  end
end
