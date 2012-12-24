class DogsController < ApplicationController
	before_filter :signed_in_user, only: [:new, :update, :edit, :create, :destroy]
	before_filter :correct_user, only: [:destroy, :edit, :update]

	def new
		@dog = current_user.dogs.build
	end

	def create
		@dog = current_user.dogs.build(params[:dog])
		if @dog.save
			flash[:success] = "Dog created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def edit
		@dog = Dog.find(params[:id])
	end

	def update
	    if @dog.update_attributes(params[:dog])
	      # Handle a successful update.
	      flash[:success] = "Dog updated"
	      redirect_to current_user
	    else
	      render 'edit'
	    end
	end

	def destroy
		@dog.destroy
		redirect_to root_url
	end

	private

		def correct_user
			@dog = current_user.dogs.find_by_id(params[:id])
			redirect_to root_url if @dog.nil?
		end
end