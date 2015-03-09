FactoryGirl.define do
  factory :org do
    sequence(:name)  {|n| "org_name_#{n}" }
  end
end
