class WalksController < ApplicationController
	before_filter :signed_in_user

	respond_to :html, :js

	def create
		@walktime = Walktime.find(params[:walk][:scheduled_id])
		@dog = @walktime.dog
		@user = @dog.user
		current_user.schedule!(@walktime)
		# UserMailer.walk_scheduled_confirmation(current_user, @walktime, @dog).deliver
		respond_with @user
	end

	def destroy
		@walktime = Walk.find(params[:id]).scheduled
		@dog = @walktime.dog
		@user = @dog.user
		current_user.unschedule!(@walktime)
		# UserMailer.walk_unscheduled_confirmation(current_user, @walktime, @dog).deliver
		respond_with @user
	end
end