class Walktime < ActiveRecord::Base
  attr_accessible :time
  belongs_to :dog

  validates :time, presence: true, numericality: { greater_than: -1, less_than: 25 }
  validates :dog_id, presence: true
end
