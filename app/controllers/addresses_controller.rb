class AddressesController < ApplicationController
	before_filter :signed_in_user, only: [:new, :create, :destroy]
	before_filter :correct_user, only: :destroy

	def index
	end

	def new
		@address = current_user.addresses.build
	end

	def create
		@address = current_user.addresses.build(params[:address])
		if @address.save
			flash[:success] = "Address Added!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@address.destroy
		redirect_to root_url
	end

	private

		def correct_user
			@address = current_user.addresses.find_by_id(params[:id])
			redirect_to root_url if @address.nil?
		end
end