FactoryGirl.define do
  factory :experience do
    sequence(:title) {|n| "job_#{n}" }
  end
end