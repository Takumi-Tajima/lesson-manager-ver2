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
      create(:lesson_date, lesson: lesson, start_at: Time.current, end_at: Time.current + 2.hours)
    end

    it 'レッスン日時が被っていない場合は許可すること' do
      lesson_date = build(:lesson_date, lesson: lesson, start_at: Time.current + 5.hours, end_at: Time.current + 6.hours)
      expect(lesson_date).to be_valid
    end

    it '同じレッスン内で重複した日時帯を許可しないこと' do
      # 同じ時間帯 (完全一致)
      lesson_date1 = build(:lesson_date, lesson: lesson, start_at: Time.current, end_at: Time.current + 2.hours)
      expect(lesson_date1).not_to be_valid
      expect(lesson_date1.errors).to be_of_kind(:base, :validate_time_slot_uniqueness)

      # 開始時間が既存の時間帯内
      lesson_date2 = build(:lesson_date, lesson: lesson, start_at: Time.current + 1.hour, end_at: Time.current + 3.hours)
      expect(lesson_date2).not_to be_valid
      expect(lesson_date2.errors).to be_of_kind(:base, :validate_time_slot_uniqueness)

      # 終了時間が既存の時間帯内
      lesson_date3 = build(:lesson_date, lesson: lesson, start_at: Time.current - 1.hour, end_at: Time.current + 1.hour)
      expect(lesson_date3).not_to be_valid
      expect(lesson_date3.errors).to be_of_kind(:base, :validate_time_slot_uniqueness)

      # 既存の時間帯を包含
      lesson_date4 = build(:lesson_date, lesson: lesson, start_at: Time.current - 1.hour, end_at: Time.current + 3.hours)
      expect(lesson_date4).not_to be_valid
      expect(lesson_date4.errors).to be_of_kind(:base, :validate_time_slot_uniqueness)

      # 既存の時間帯に包含される
      lesson_date5 = build(:lesson_date, lesson: lesson, start_at: Time.current + 30.minutes, end_at: Time.current + 1.hour)
      expect(lesson_date5).not_to be_valid
      expect(lesson_date5.errors).to be_of_kind(:base, :validate_time_slot_uniqueness)
    end
  end
end
