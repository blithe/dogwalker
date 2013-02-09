class Walk < ActiveRecord::Base
  attr_accessible :scheduled_id

  belongs_to :scheduler, class_name: "User"
  belongs_to :scheduled, class_name: "Walktime"

  validates :scheduler_id, presence: true
  validates :scheduled_id, presence: true
  validates_uniqueness_of :scheduled_id
end
