class AddAvatarToDogs < ActiveRecord::Migration
  def self.up
    add_attachment :dogs, :avatar
  end

  def self.down
    remove_attachment :dogd, :avatar
  end
end
