FactoryGirl.define do
  factory :job_post do
    sequence(:title) {|n| "job_post_#{n}" }
  end
end
