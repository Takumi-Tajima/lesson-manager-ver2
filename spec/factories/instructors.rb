FactoryBot.define do
  factory :instructor do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
  end
end
