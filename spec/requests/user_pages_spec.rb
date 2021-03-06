require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it "should not be able to destroy itself" do
          sign_in admin
          expect { delete user_path(admin) }.to_not change(User, :count).by(-1)
        end

        it { should have_link('delete', href: user_path(User.first)) }
        
        it "should be able to delete another user" do
          expect { delete user_path(user) }.to change(User, :count).by(-1)
        end
        
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end


  describe "signup" do
  	before { visit signup_path }

  	let(:submit) { "Create my account" }

  	describe "with invalid information" do
  		it "should not create a user" do
  			expect { click_button submit }.not_to change(User, :count)
  		end
  	
  		describe "after submission" do
  			before { click_button submit }

  			it { should have_selector('title', text: 'Sign up') }
  			it { should have_content('error') }
  		end
  	end

  	describe "with valid information" do
  		before do
  			fill_in "Name",				with: "Example User"
  			fill_in "Email",			with: "user@example.com"
  			fill_in "Password",			with: "foobar"
  			fill_in "Confirmation",		with: "foobar"
  		end

  		it "should create a user" do
  			expect { click_button submit }.to change(User, :count).by(1)
  		end

  		describe "after saving the user" do
  			before { click_button submit }
  			let(:user) { User.find_by_email('user@example.com') }

  			it { should have_selector('title', text: user.name) }
  			it { should have_success_message('Welcome') }
  			it { should have_link('Sign out') }
  		end
  	end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

 describe "profile page" do
    before(:all) { User.delete_all }
    let(:user) { FactoryGirl.create(:user) }
    let!(:d1) { FactoryGirl.create(:dog, user: user, name: "Nola") }
    let!(:d2) { FactoryGirl.create(:dog, user: user, name: "Snoopy") }
    let!(:wt1) { FactoryGirl.create(:walktime, dog: d1, time: 10) }
    let!(:wt2) { FactoryGirl.create(:walktime, dog: d1, time: 20) }
    let!(:old_address) { FactoryGirl.create(:address, user: user, street: "1 Snoopy", city: "ATL", state: "GA", zipcode: "90210", created_at: 1.day.ago) }
    let!(:new_address) { FactoryGirl.create(:address, user: user, street: "2 Snoopy", city: "Atlanta", state: "Georgia", zipcode: "90211", created_at: 1.hour.ago) }

    before do
      sign_in user
      visit user_path(user)
    end

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
    
    describe "should have dogs" do
      it { should have_content(d1.name) }
      it { should have_content(d2.name) }
    end

    describe "should have dogs' walktimes" do
      it { should have_content(wt1.time_from_integer) }
      it { should have_content(wt2.time_from_integer) }
    end

    describe "should have current address" do
      it { should have_content(new_address.street) }
      it { should have_content(new_address.city) }
      it { should have_content(new_address.state) }
      it { should have_content(new_address.zipcode) }
    end

    describe "should have old address" do
      it { should have_content(old_address.street) }
      it { should have_content(old_address.city) }
      it { should have_content(old_address.state) }
      it { should have_content(old_address.zipcode) }
    end

    describe "should have follower/following counts" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        other_user.follow!(user)
        visit user_path(user)
      end

      it { should have_link("0 following", href: following_user_path(user)) }
      it { should have_link("1 followers", href: followers_user_path(user)) }
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other uses's folowers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: 'Unfollow') }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other uses's folowers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end
      end
    end

    describe "schedule/unschedule buttons" do
      let(:dog) { FactoryGirl.create(:dog, user: user) }
      let(:walktime) { FactoryGirl.create(:walktime, dog: dog) }
      before { sign_in user }

      describe "scheduling a walktime" do
        before { visit user_path(user) }

        it { should have_selector('input', value: 'Schedule') }

        it "should increment the scheduled walktimes count" do
          expect do
            click_button "Schedule"
          end.to change(user.scheduled_walktimes, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Schedule" }
          it { should have_selector('input', value: 'Unschedule') }
        end  
      end

      describe "for a time that is already scheduled" do
        let(:other_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        before do
          other_user.schedule!(walktime)
          sign_in user
          visit user_path(user)
        end

        it { should_not have_button('Unschedule') }
        it "should not have a Schedule button" do
          pending("figuring out why this fails")
          page.should_not have_button('Schedule')
        end
      end

      describe "unscheduling a walktime" do
        before do
          user.schedule!(walktime)
          visit user_path(user)
        end

        it "should decrement the scheduled walktime count" do
          expect do
            click_button "#{walktime.id}" 
          end.to change(user.scheduled_walktimes, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unschedule" }
          it { should have_selector('input', value: 'Schedule') }
        end
      end
    end
  end

 describe "edit" do
 	let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
    visit edit_user_path(user)
  end
 	before { visit edit_user_path(user) }

 	describe "page" do
 		it { should have_selector('h1', text: "Update your profile") }
 		it { should have_selector('title', text: "Edit user") }
 		it { should have_link('change', href: 'http://gravatar.com/emails') }
 	end

 	describe "with invalid information" do
 		before { click_button "Save changes" }

 		it { should have_content('error') }
 	end

  describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_success_message('') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
  end 
 end

 describe "following/followers" do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  before { user.follow!(other_user) }

  describe "followed users" do
    before do
      sign_in user
      visit following_user_path(user)
    end

    it { should have_selector('title', text: full_title('Following')) }
    it { should have_selector('h3', text: 'Following') }
    it { should have_link(other_user.name, href: user_path(other_user)) }
  end

  describe "followers" do
    before do
      sign_in other_user
      visit followers_user_path(other_user)
    end

    it { should have_selector('title', text: full_title('Followers')) }
    it { should have_selector('h3', text: 'Followers') }
    it { should have_link(user.name, href: user_path(user)) }
    end
  end
end







