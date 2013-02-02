class WalksController < ApplicationController
	before_filter :signed_in_user

	respond_to :html, :js

	def create
		@walktime = Walktime.find(params[:walk][:scheduled_id])
		current_user.schedule!(@walktime)
		respond_with @walktime.dog.user
	end

	def destroy
		@walktime = Walk.find(params[:id]).scheduled
		current_user.unschedule!(@walktime)
		respond_with @walktime.dog.user
	end
end