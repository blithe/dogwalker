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

  describe "page" do
    it { should have_selector('h1', text: "Update your dog") }
    it { should have_selector('title', text: "Edit dog") }
  end
 end
end
