class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@walks = current_user.walks.paginate(page: params[:page])
  	end
  end
end
