FactoryBot.define do
  factory :lesson_date do
    lesson
    start_at { Faker::Time.forward }
    end_at { start_at + 30.minutes }
    capacity { 1 }
    url { 'https://www.example.com' }
  end
end
