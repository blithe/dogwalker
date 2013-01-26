require 'spec_helper'

describe Walktime do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:dog) { FactoryGirl.create(:dog, user: user, name: "Snoopy") }
  
  before { @walktime = dog.walktimes.build(time: 20) }

  subject { @walktime }

  it { should respond_to(:time) }
  it { should respond_to(:dog_id) }
  it { should respond_to(:dog) }
  its(:dog) { should == dog }

  it { should be_valid }

  describe "when dog_id is not present" do
  	before { @walktime.dog_id = nil }
  	it { should_not be_valid }
  end

  describe "accessible attributes" do
  	it " should not allow access to dog_id" do
  		expect do
  			Walktime.new(dog_id: dog.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end

  describe "with no time" do
  	before { @walktime.time = " " }
  	it { should_not be_valid }
  end

  describe "with time that is not an integer" do
  	before { @walktime.time = "a" }
  	it { should_not be_valid }
  end
end
