FactoryGirl.define do
  factory :message do
    sequence(:note) {|n| "note_#{n}" }
  end
end