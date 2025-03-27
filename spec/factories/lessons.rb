FactoryBot.define do
  factory :lesson do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    instructor
    published_at { Time.current }

    trait :unpublished do
      published_at { nil }
    end
  end
end
