class CreateWalktimes < ActiveRecord::Migration
  def change
    create_table :walktimes do |t|
      t.integer :time
      t.integer :dog_id

      t.timestamps
    end
    add_index :walktimes, [:dog_id]
  end
end
