class Address < ActiveRecord::Base
  attr_accessible :city, :state, :street, :zipcode, :latitude, :longitude
  belongs_to :user
  geocoded_by :full_street_address
  after_validation :geocode

  default_scope order: 'addresses.updated_at DESC'

  validates :user_id, presence: true
  validates :street, presence: true, length: { minimum: 2 }
  validates :city, presence: true, length: { minimum: 2 }
  validates :state, presence: true, length: { minimum: 2 }
  validates :zipcode, presence: true, length: { is: 5 }, numericality: :only_integer

  def full_street_address
  	[street, city, state, zipcode].compact.join(', ')
  end
end
