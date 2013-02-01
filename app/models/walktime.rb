class Walktime < ActiveRecord::Base
  attr_accessible :time
  belongs_to :dog

  has_many :schedulers, through: :reverse_walks, source: :scheduler
  has_many :reverse_walks, foreign_key: "scheduled_id", class_name: "Walk", dependent: :destroy

  validates :time, presence: true, numericality: { 	only_integer: true,
  													greater_than_or_equal_to: 0,
  													less_than_or_equal_to: 23 }
  validates :dog_id, presence: true
  validates_uniqueness_of :time

  default_scope order: 'walktimes.time ASC'

	def time_from_integer
		times = times_array
		
		return times[self.time][0]
	end

	def times_array
		times = [["12:00 am", 0], ["1:00 am", 1], ["2:00 am", 2], ["3:00 am", 3], ["4:00 am", 4], 
						 ["5:00 am", 5], ["6:00 am", 6], ["7:00 am", 7], ["8:00 am", 8], ["9:00 am", 9], 
						 ["10:00 am", 10], ["11:00 am", 11], ["12:00 pm", 12], ["1:00 pm", 13], ["2:00 pm", 14], 
						 ["3:00 pm", 15], ["4:00 pm", 16], ["5:00 pm", 17], ["6:00 pm", 18], ["7:00 pm", 19], 
						 ["8:00 pm", 20], ["9:00 pm", 21], ["10:00 pm", 22], ["11:00 pm", 23]]
	end
end
