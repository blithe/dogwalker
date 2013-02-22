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

  def address
    self.user.addresses.first
  end

  def available_times
    available = []    
    
    Walktime.new.times_array.each do |time|
      # if dog does not already have walk time, return it
      if taken_times.include?(time[1])
        # skip it
      else
        available.push(time)
      end
    end

    return available
  end 

  def taken_times
    taken = []

    walktimes.each do |walktime|
      taken.push(walktime.time)
    end 

    return taken
  end
end
