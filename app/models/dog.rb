class Dog < ActiveRecord::Base
  attr_accessible :name, :avatar
  belongs_to :user
  has_many :walktimes, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }, 
  default_url: "https://s3.amazonaws.com/blitherocher/dogs/avatars/default_dog.gif"
end
