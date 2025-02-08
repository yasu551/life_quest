FactoryBot.define do
  factory :push_subscription do
    user { nil }
    endpoint { "MyString" }
    p256dh_key { "MyString" }
    auth_key { "MyString" }
    user_agent { "MyString" }
  end
end
