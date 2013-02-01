class CreateWalks < ActiveRecord::Migration
  def change
    create_table :walks do |t|
      t.integer :scheduler_id
      t.integer :scheduled_id

      t.timestamps
    end

    add_index :walks, :scheduler_id
    add_index :walks, :scheduled_id
    add_index :walks, [:scheduler_id, :scheduled_id], unique: true
  end
end
