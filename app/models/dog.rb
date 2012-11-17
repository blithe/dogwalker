class Dog < ActiveRecord::Base
  attr_accessible :name
  belongs_to :user
  has_many :walktimes, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
end
