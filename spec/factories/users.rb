FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "user_#{n}@example.com" }
    password { "password" }
  end
end
