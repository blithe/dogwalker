class Address < ActiveRecord::Base
  attr_accessible :city, :state, :street, :zipcode
  belongs_to :user

  validates :user_id, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true

  default_scope order: 'addresses.created_at DESC'
end
