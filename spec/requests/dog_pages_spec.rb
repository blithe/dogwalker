require 'spec_helper'

describe "Dog Pages" do
  subject { page }

  describe "edit" do
  let(:user) { FactoryGirl.create(:user) }
  let!(:dog) { FactoryGirl.create(:dog, user: user, name: "Nola") }

  before do
    sign_in user
    visit edit_dog_path(dog)
  end
  before { visit edit_dog_path(dog) }

  describe "page" do
    it { should have_selector('h1', text: "Update your dog") }
    it { should have_selector('title', text: "Edit dog") }
  end

  describe "with invalid information" do
    let(:bad_name)  { "" }
      before do
        fill_in "Name",             with: bad_name
        click_button "Save changes"
      end

    it { should have_content('error') }
  end

  describe "with valid information" do
      let(:new_name)  { "New Name" }
      before do
        fill_in "Name",             with: new_name
        click_button "Save changes"
      end

      it { should have_content(new_name) }
      it { should have_success_message('') }
      it { should have_link('Sign out', href: signout_path) }
      specify { dog.reload.name.should  == new_name }
  end
 end
end
