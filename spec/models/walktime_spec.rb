require 'spec_helper'

describe Walktime do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:dog) { FactoryGirl.create(:dog, user: user, name: "Snoopy") }
  let(:walktime) { FactoryGirl.create(:walktime, dog: dog, time: 20) }

  subject { walktime }

  it { should respond_to(:time) }
  it { should respond_to(:dog_id) }
  it { should respond_to(:dog) }
  it { should respond_to(:reverse_walks) }
  it { should respond_to(:schedulers) }
  its(:dog) { should == dog }

  it { should be_valid }

  describe "when dog_id is not present" do
  	before { walktime.dog_id = nil }
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
  	before { walktime.time = " " }
  	it { should_not be_valid }
  end

  describe "with time that is not an integer" do
  	before { walktime.time = "a" }
  	it { should_not be_valid }
  end

  describe "walking" do
    before do
      user.save
      user.schedule!(walktime)
    end

    describe "scheduled walktime" do
      subject { walktime }
      its(:schedulers) { should include(user) }
    end

    it "should destroy associated walks" do
      walks = walktime.reverse_walks
      walktime.destroy
      walks.each do |walk|
        Walk.find_by_id(scheduler.id).should be_nil
      end
    end
  end
end
