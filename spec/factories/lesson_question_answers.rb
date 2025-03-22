FactoryBot.define do
  factory :lesson_question_answer do
    reservation
    question { Faker::Lorem.sentence }
    answer { Faker::Lorem.sentence }
  end
end
