class CreateProcessedFiles < ActiveRecord::Migration
  def change
    create_table :processed_files do |t|
      t.string :fie_name, null: false

      t.timestamps null: false
    end
  end
end
