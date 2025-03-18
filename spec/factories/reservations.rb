FactoryBot.define do
  factory :reservation do
    lesson_date
    user
    lesson_name { Faker::Lorem.word }
    instructor_name { Faker::Name.name }
    lesson_description { Faker::Lorem.sentence }
    start_at { Faker::Time.forward }
    end_at { start_at + 30.minutes }
  end
end
