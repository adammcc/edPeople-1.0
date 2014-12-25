FactoryGirl.define do
  factory :subject do
    sequence(:name) {|n| "subject_#{n}" }
  end
end