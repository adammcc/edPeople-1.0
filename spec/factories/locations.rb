FactoryGirl.define do
  factory :location do
    sequence(:name) {|n| "location_#{n}" }
  end
end