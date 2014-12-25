FactoryGirl.define do
  factory :college_info do
    sequence(:name) {|n| "school_#{n}" }
  end
end