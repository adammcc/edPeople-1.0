FactoryGirl.define do
  factory :skill do
    sequence(:name) {|n| "skill_#{n}" }
  end
end