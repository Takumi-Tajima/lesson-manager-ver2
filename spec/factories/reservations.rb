FactoryBot.define do
  factory :reservation do
    lesson_date { nil }
    user { nil }
    lesson_name { "MyString" }
    instructor_name { "MyString" }
    lesson_description { "MyText" }
    start_at { "2025-03-17 22:55:47" }
    end_at { "2025-03-17 22:55:47" }
  end
end
