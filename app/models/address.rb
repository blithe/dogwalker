class Address < ActiveRecord::Base
  attr_accessible :city, :state, :street, :zipcode, :latitude, :longitude
  belongs_to :user
  geocoded_by :full_street_address
  after_validation :geocode

  validates :user_id, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true

  default_scope order: 'addresses.created_at DESC'

  def full_street_address
  	[street, city, state, zipcode].compact.join(', ')
  end
end
