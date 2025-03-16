require 'rails_helper'

RSpec.describe LessonDate, type: :model do
  describe 'url' do
    it '適切なURLの場合のみ許可すること' do
      lesson_date1 = build(:lesson_date, url: 'https://www.example.com')
      expect(lesson_date1).to be_valid

      lesson_date2 = build(:lesson_date, url: 'http://www.example.com')
      expect(lesson_date2).to be_valid

      lesson_date3 = build(:lesson_date, url: 'www.example.com')
      expect(lesson_date3).not_to be_valid
      expect(lesson_date3.errors).to be_of_kind(:url, :invalid)

      lesson_date4 = build(:lesson_date, url: 'これはURLです')
      expect(lesson_date4).not_to be_valid
      expect(lesson_date4.errors).to be_of_kind(:url, :invalid)
    end
  end

  describe 'レッスン日時帯の重複' do
    let(:lesson) { create(:lesson) }

    before do
      travel_to '2025-03-15 09:00:00'
      create(:lesson_date, lesson: lesson, start_at: '2025-03-15 10:00:00', end_at: '2025-03-15 12:00:00')
    end

    it '同じレッスン内で重複した日時帯を許可しないこと' do
      lesson_date = build(:lesson_date, lesson: lesson, start_at: '2025-03-15 10:00:00', end_at: '2025-03-15 12:00:00')
      expect(lesson_date).not_to be_valid
      expect(lesson_date.errors).to be_of_kind(:base, :validate_time_slot_uniqueness)
    end
  end
end
