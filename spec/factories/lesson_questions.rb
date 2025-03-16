FactoryBot.define do
  factory :lesson_question do
    lesson
    content { Faker::Lorem.sentence }
  end
end
