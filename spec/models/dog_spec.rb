require 'spec_helper'

describe Dog do
  let(:user) { FactoryGirl.create(:user) }
  before { @dog = user.dogs.build(name: "Nola") }

  subject { @dog }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:walktimes) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @dog.user_id = nil }
  	it { should_not be_valid }
  end

  describe "with no name" do
  	before { @dog.name = " " }
  	it { should_not be_valid }
  end

  describe "with name that is too long" do
  	before { @dog.name = "a" * 101 }
  	it { should_not be_valid}
  end

  describe "accessible attributes" do
  	it "should not allow access to user_id" do
  		expect do
  			Dog.new(user_id: user.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end

  describe "walktime associations" do
    before { @dog.save }
    let!(:wt1) do
      FactoryGirl.create(:walktime, dog: @dog)
    end
    let!(:wt2) do
      FactoryGirl.create(:walktime, dog: @dog)
    end

    it "should destroy associated walktimes" do
      walktimes = @dog.walktimes.dup
      @dog.destroy
      walktimes.should_not be_empty
      walktimes.each do |walktime|
        Walktime.find_by_id(walktime.id).should be_nil
      end
    end
  end
end
