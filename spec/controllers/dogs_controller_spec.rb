require 'spec_helper'

describe DogsController do
	let(:user) { FactoryGirl.create(:user) }
	let(:dog) { user.dogs(build(name: "Fifi")) }

	describe "GET #new" do
		it "assigns a new Dog to @dog"
	end

	describe "POST #create" do
		context "with valid attributes" do
			it "saves the new dog in the datase"
			it "flashes success message"
			it "redirects to home page"
		end

		context "with invalid attributes" do
			it "flashes error message"
			it "redirects to home page"
		end
	end

	describe "DELETE #destroy" do
		it "should delete dog from datbase"
		it "should redirect to the home page"
	end
end