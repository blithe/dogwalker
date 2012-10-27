class CreateDogs < ActiveRecord::Migration
  def change
    create_table :dogs do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
    add_index :dogs, [:user_id]
  end
end
