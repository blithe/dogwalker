require 'spec_helper'

describe Walk do
  let(:scheduler) { FactoryGirl.create(:user) }
  let(:dog) { FactoryGirl.create(:dog, user: scheduler, name: "Snoopy") }
  let(:scheduled) { FactoryGirl.create(:walktime, dog: dog, time: 20) }
  let(:walk) { scheduler.walks.build(scheduled_id: scheduled.id) }

  subject { walk }

  it { should be_valid }

  describe "accessible attributes" do
  	it "should not allow access to scheduler_id" do
  		expect do
  			Walk.new(scheduler_id: scheduler.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end

  describe "scheduler methods" do
    it { should respond_to(:scheduler) }
    it { should respond_to(:scheduled) }
    its(:scheduler) { should == scheduler }
    its(:scheduled) { should == scheduled }
  end

  describe "when scheduled id is not present" do
    before { walk.scheduled_id = nil }
    it { should_not be_valid }
  end

  describe "when scheduler id is not present" do
    before { walk.scheduler_id = nil }
    it { should_not be_valid }
  end
end
