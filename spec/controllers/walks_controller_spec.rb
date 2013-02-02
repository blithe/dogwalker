require 'spec_helper'

describe WalksController do
	let(:user) { FactoryGirl.create(:user) }
	let(:dog) { FactoryGirl.create(:dog, user: user) }
	let(:walktime) { FactoryGirl.create(:walktime, dog: dog) }

	before { sign_in user }

	describe "creating a walk with Ajax" do
		
		it "should increment the Walk count" do
			expect do
				xhr :post, :create, walk: { scheduled_id: walktime.id }
			end.to change(Walk, :count).by(1)
		end

		it "should respond with success" do
			xhr :post, :create, walk: { scheduled_id: walktime.id }
			response.should be_success
		end
	end

	describe "destroying a walk with Ajax" do
		before {user.schedule!(walktime) }
		let(:walk) { user.walks.find_by_scheduled_id(walktime) }

		it "should decrement the Walk count" do
			expect do
				xhr :delete, :destroy, id: walk.id
			end.to change(Walk, :count).by(-1)
		end

		it "should respond with success" do
			xhr :delete, :destroy, id: walk.id
			response.should be_success
		end
	end
end
