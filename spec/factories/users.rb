FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "asdf#{n}@asdf.com" }
    password         'asdfasdf'

    sequence(:first_name)  {|n| "First_#{n}" }
    sequence(:last_name)  {|n| "Last_#{n}" }

    confirmed_at  { DateTime.now }
  end
end
