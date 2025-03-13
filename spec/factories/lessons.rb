FactoryBot.define do
  factory :lesson do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    instructor
  end
end
