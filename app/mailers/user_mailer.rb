class UserMailer < ActionMailer::Base
  default from: "dogwalkerapp@gmail.com"

  def registration_confirmation(user)
  	@user = user
  	mail(:to => "#{user.name} <#{user.email}>", :subject => "Created account!")
  end

  def scheduled_walk_confirmation()
  	@user = user
  	mail(:to => "#{user.name} <#{user.email}>", :subject => "Scheduled walk!")
  end
end
