require 'spec_helper'

describe Address do
  
  let(:user) { FactoryGirl.create(:user) }
  before { @address = user.addresses.build(street: "1 Infinite Loop", city: "Cupertino", state: "CA", zipcode: "90210") }

  subject { @address }

  it { should respond_to(:street) }
  it { should respond_to(:city) }
  it { should respond_to(:state) }
  it { should respond_to(:zipcode) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @address.user_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank street" do
    before { @address.street = " " }
    it { should_not be_valid }
  end

  describe "with blank city" do
    before { @address.city = " " }
    it { should_not be_valid }
  end

  describe "with blank state" do
    before { @address.state = " " }
    it { should_not be_valid }
  end

  describe "with blank zipcode" do
    before { @address.zipcode = " " }
    it { should_not be_valid }
  end

  describe "accessible attributes" do
  	it " should not allow access to user_id" do
  		expect do
  			Address.new(user_id: user.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end
end
