require 'rails_helper'

RSpec.describe 'ゲストのレッスン閲覧', type: :system do
  describe '一覧と詳細のデータ表示' do
    let(:instructor) { create(:instructor, name: '田島 匠') }
    let(:lesson) { create(:lesson, name: 'オンライン秘書検定', description: '秘書になれる極意を教えます', instructor: instructor) }

    before do
      create(:lesson_date, start_at: Time.current + 1.hour, end_at: Time.current + 2.hours, capacity: 5, lesson: lesson)
    end

    it 'ゲストはレッスンの一覧と詳細データを閲覧できること' do
      visit root_path

      expect(page).to have_selector 'h1', text: 'レッスン一覧'

      expect(page).to have_content 'オンライン秘書検定'
      expect(page).to have_content '田島 匠'

      click_on 'オンライン秘書検定'

      expect(page).to have_selector 'h1', text: 'オンライン秘書検定'
      expect(page).to have_content 'レッスン詳細: 秘書になれる極意を教えます'
      expect(page).to have_content '講師: 田島 匠'

      expect(page).to have_selector 'h2', text: 'レッスンの開催日'
      expect(page).to have_content '開始日時'
      expect(page).to have_content '終了日時'
      expect(page).to have_content '予約人数'
      expect(page).to have_content '定員'
      expect(page).to have_content '5'
    end
  end
end
