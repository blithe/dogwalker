class WalktimesController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy]
	before_filter :correct_user, only: :destroy

	def create
		@dog = current_user.dogs.find_by_id(params[:walktime][:dog_id])
		@walktime = @dog.walktimes.new
		@walktime.time = params[:walktime][:time]
		@walktime.dog = @dog
		if @walktime.save
			flash[:success] = "Walktime added!"
		else
			flash[:error] = "Error saving walktime!"
		end
		redirect_to edit_dog_path(@dog)
	end

	def destroy
		@walktime = Walktime.find_by_id(params[:id])
		@dog = @walktime.dog
		if @walktime.destroy
			flash[:success] = "Walktime deleted!"
		else
			flash[:error] = "Error deleting walktime!"
		end
		redirect_to edit_dog_path(@dog)
	end

	private

		def correct_user
			@walktime = Walktime.find_by_id(params[:id])
			@dog = current_user.dogs.find_by_id(@walktime.dog_id)
			redirect_to root_url if @dog.nil?
		end
end