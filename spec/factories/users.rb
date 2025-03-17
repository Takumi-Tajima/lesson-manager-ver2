FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    confirmed_at { Time.current }
  end
end
