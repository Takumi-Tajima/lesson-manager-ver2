FactoryBot.define do
  factory :lesson do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    instructor
    published_at { Time.current }
  end
end
