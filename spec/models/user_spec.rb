# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
  before do
  	@user = User.new(name: "Example User", email: "user@example.com", 
                      password: "foobar", password_confirmation: "foobar")
  end
  subject { @user }

  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  
  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end
  

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:walks) }
  it { should respond_to(:scheduled_walktimes) }
  it { should respond_to(:walking?) }
  it { should respond_to(:schedule!) }
  it { should respond_to(:addresses) }
  it { should respond_to(:dogs) }
  it { should respond_to(:feed) }

  it { should be_valid }

  describe "when name is not present" do
  	before { @user.name = " " }
  	it { should_not be_valid }
  end

  describe "when email is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "when name is too long" do
  	before { @user.name = "a" * 51 }
  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
  	it "should be invalid" do
  		addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
  		addresses.each do |invalid_address|
  			@user.email = invalid_address
  			@user.should_not be_valid
  		end
  	end
  end

  describe "when email format is valid" do
  	it "should be valid" do
  		addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
  		addresses.each do |valid_address|
  			@user.email = valid_address
  			@user.should be_valid
  		end
  	end
  end

  describe "when email address is already taken" do
  	before do
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	end

  	it { should_not be_valid }
  end

  describe "email address with mixed case" do
  	let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

  	it "should be save as all lower-case" do
  		@user.email = mixed_case_email
  		@user.save
  		@user.reload.email.should == mixed_case_email.downcase
  	end
  end

  describe "when password is not present" do
  	before { @user.password = @user.password_confirmation = " " }
  	it { should_not be_valid}
  end  

  describe "when password doesn't match confirmation" do
  	before { @user. password_confirmation = "mismatch" }
  	it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
  	before { @user.password_confirmation = nil }
  	it { should_not be_valid }
  end  

  describe "with a password that's too short" do
  	before { @user.password = @user.password_confirmation = "a" * 5 }
  	it { should be_invalid }
  end

  describe "return value of authenticate method" do
  	before { @user.save }
  	let(:found_user) { User.find_by_email(@user.email) }

  	describe "with valid password" do
  		it { should == found_user.authenticate(@user.password) }
  	end

  	describe "with invalid password" do
  		let(:user_for_invalid_password) { found_user.authenticate("invalid") }

  		it { should_not == user_for_invalid_password }
  		specify { user_for_invalid_password.should be_false }
  	end
  end	

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank}
  end

  describe "dog associations" do
    before { @user.save }
    let!(:older_dog) { FactoryGirl.create(:dog, user: @user) }
    let!(:younger_dog) { FactoryGirl.create(:dog, user: @user) }

    it "should destroy associated dogs" do
      dogs = @user.dogs.dup
      @user.destroy
      dogs.should_not be_empty
      dogs.each do |dog|
        Dog.find_by_id(dog.id).should be_nil
      end
    end
  end



  describe "address associations" do
    before { @user.save }
    let!(:old_address) { FactoryGirl.create(:address, user: @user, created_at: 1.day.ago) }
    let!(:new_address) { FactoryGirl.create(:address, user: @user, created_at: 1.hour.ago) }

    it "should have the right addresses in the right order" do
      @user.addresses.should == [new_address, old_address]
    end

    it "should destroy associated addresses" do
      addresses = @user.addresses.dup
      @user.destroy
      addresses.should_not be_empty
      addresses.each do |address|
        Address.find_by_id(address.id).should be_nil
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }
    
    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end

    it "should destroy associated relationships" do
      relationships = @user.relationships
      @user.destroy
      relationships.each do |relationship|
        Relationship.find_by_id(followed.id).should be_nil
      end
    end
  end

  describe "walking" do
    let(:dog) { FactoryGirl.create(:dog, user: @user, name: "Snoopy") }
    let(:walktime) { FactoryGirl.create(:walktime, dog: dog, time: 20) }
    before do
      @user.save
      @user.schedule!(walktime)
    end

    it { should be_walking(walktime) }
    its(:scheduled_walktimes) { should include(walktime) }

    describe "and unscheduling" do
      before { @user.unschedule!(walktime) }

      it { should_not be_walking(walktime) }
      its(:scheduled_walktimes) { should_not include(walktime) }
    end

    it "should destroy associated walks" do
      walks = @user.walks
      @user.destroy
      walks.each do |walk|
        Walk.find_by_id(scheduled.id).should be_nil
      end
    end
  end
end







