class Walktime < ActiveRecord::Base
  attr_accessible :time
  belongs_to :dog

  validates :time, presence: true, numericality: { 	only_integer: true,
  													greater_than_or_equal_to: 0,
  													less_than_or_equal_to: 24 }
  validates :dog_id, presence: true
end
