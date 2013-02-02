require 'spec_helper'

describe "StaticPages" do
  let(:base_title) { "Dogwalker App" }
  subject { page }
  
   shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
  	before { visit root_path}
    let(:heading)		{ 'Dogwalker App' }
    let(:page_title)	{ '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:address) { FactoryGirl.create(:address, user: user, street: "110 Portia") }
      let(:dog) { FactoryGirl.create(:dog, user: user, name: "Snoopy") }
      let(:walktime) { FactoryGirl.create(:walktime, dog: dog, time: 20) }
      before do
        sign_in user
        user.schedule!(walktime)
        visit root_path
      end

      it "should render the user's feed" do
        
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.scheduled.time_from_integer)
        end
      end

      describe "scheduled count" do
        it { should have_content("Scheduled Walks (1)") }
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  it "should have the right links on the layout" do
  	visit root_path
  	
  	click_link "Home"
  	click_link "Sign up now!"
  	page.should have_selector 'title', text: full_title('Sign up')
  	click_link "dogwalker app"
  	page.should have_selector 'title', text: full_title('')
  end
end
