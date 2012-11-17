class WalktimesController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy]
	before_filter :correct_user, only: :destroy

	def index
	end

	def create
		@mwalktime = current_user.dogs.walktimes.build(params[:walktime])
		if @walktime.save
			flash[:success] = "Created walk time."
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@walktime.destroy
		redirect_to root_url
	end

	private

		def correct_user
			@walktime = current_user.dogs.walktimes.find_by_id(params[:id])
			redirect_to root_url if @walktime.nil?
		end
end