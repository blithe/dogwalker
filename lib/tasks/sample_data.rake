namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_dogs
    make_relationships
    make_addresses
    make_walktimes
  end
end

def make_users
  admin = User.create!(name: "Example User", email: "example@railstutorial.org", password: "foobar", password_confirmation: "foobar")
  admin.toggle!(:admin)

  10.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = User.all(limit: 6)
    
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_dogs
  users = User.all(limit: 6)
    
  2.times do
    name = Faker::Name.name
    users.each { |user| user.dogs.create!(name: name) }
  end
end

def make_walktimes
  dogs = Dog.all
  
  dogs.each { |dog| dog.walktimes.create!(time: 10) }
  dogs.each { |dog| dog.walktimes.create!(time: 20) }

end

def make_addresses
  users = User.all(limit: 6)
    
  2.times do
    street = Faker::Address.street_address
    city = Faker::Address.city
    state = Faker::Address.us_state
    zipcode = Faker::Address.zip_code
    users.each { |user| user.addresses.create!(street: street,
                                              city: city,
                                              state: state,
                                              zipcode: zipcode) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end