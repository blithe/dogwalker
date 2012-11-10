class RemoveColumns < ActiveRecord::Migration
  def up
  	remove_column :users, [:street, :city, :state, :zipcode]
  end

  def down
  end
end
