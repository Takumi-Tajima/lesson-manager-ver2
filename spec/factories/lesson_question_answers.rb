FactoryBot.define do
  factory :lesson_question_answer do
    reservation_id { nil }
    question { "MyString" }
    answer { "MyString" }
  end
end
