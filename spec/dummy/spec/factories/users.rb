FactoryGirl.define do
  sequence(:email) { |n| "ios_user-#{n}@example.com" }
  factory :user do
    email
    password 'alcatraz'

    trait :full do
      reset_password_token { Devise.token_generator.generate(User, :reset_password_token) }
      reset_password_sent_at { Time.now }
      remember_created_at { Time.now }
    end
  end

  factory :oauth_user, class: User do
    provider 'facebook'
    oauth_token 'valid_token'
    uid { rand(1000..9999) }
  end
end
