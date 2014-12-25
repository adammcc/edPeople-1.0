FactoryGirl.define do
  factory :college do
    sequence(:name) {|n| "school_#{n}" }
  end
end
