FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "yard#{n}@theironyard.com" }
  end
end
