class UserMailer < ActionMailer::Base
  default from: "dogwalkerapp@gmail.com"

  def registration_confirmation(user)
  	@user = user
  	mail(:to => "#{user.name} <#{user.email}>", :subject => "Created account!")
  end

  def walk_scheduled_confirmation(user, walktime, dog)
  	@user = user
  	@dog = dog
  	@walktime = walktime
  	mail(:to => "#{user.name} <#{user.email}>", :subject => "Scheduled walk!")
  end

  def walk_unscheduled_confirmation(user, walktime, dog)
  	@user = user
  	@dog = dog
  	@walktime = walktime
  	mail(:to => "#{user.name} <#{user.email}>", :subject => "Cancelled walk!")
  end
end
