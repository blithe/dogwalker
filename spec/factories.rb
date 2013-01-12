FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"


		factory :admin do
			admin true
		end
	end


	factory :address do
		sequence(:street) { |n| "#{n} Infinite Loop" }
		city "Cupertino"
		state "CA"
		zipcode 90210
		user
	end

	factory :dog do
		sequence(:name) { |n| "Snoopy#{n}" }
		user
	end

	factory :walktime do
		sequence(:time) { |n| "#{n}" }
		dog
	end
end