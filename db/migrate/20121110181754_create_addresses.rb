class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :state
      t.integer :zipcode
      t.integer :user_id

      t.timestamps
    end
    add_index :addresses, [:user_id, :created_at]
  end
end
