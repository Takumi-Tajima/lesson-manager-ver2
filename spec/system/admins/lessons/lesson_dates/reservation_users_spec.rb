require 'rails_helper'

RSpec.describe '予約したユーザー情報の閲覧', type: :system do
  let(:admin) { create(:admin) }

  before { sign_in admin }

  describe '予約したユーザー一覧' do
    let(:user) { create(:user, id: 5, name: '佐々木武蔵', email: 'sasaki@example.com') }
    let(:lesson) { create(:lesson, id: 8, name: '超実践型オンラインカバディ') }
    let(:lesson_date) { create(:lesson_date, id: 20, lesson: lesson, capacity: 5) }

    before { create(:reservation, user: user, lesson_date: lesson_date) }

    it '予約したユーザーの一覧情報を閲覧できること' do
      visit admins_root_path

      expect(page).to have_selector 'h1', text: 'レッスン一覧'
      expect(page).to have_content '超実践型オンラインカバディ'

      click_on '8'

      expect(page).to have_selector 'h1', text: '超実践型オンラインカバディ'
      expect(page).to have_selector 'h2', text: 'レッスン日時'

      find_link('20').click

      expect(page).to have_selector 'h1', text: '超実践型オンラインカバディ'

      click_on '予約ユーザー一覧へ'

      expect(page).to have_selector 'h1', text: '予約しているユーザー一覧'
      expect(page).to have_content 'ID'
      expect(page).to have_content '名前'
      expect(page).to have_content 'メールアドレス'
      expect(page).to have_content '5'
      expect(page).to have_content '佐々木武蔵'
      expect(page).to have_content 'sasaki@example.com'
    end
  end

  describe '予約したユーザーの詳細' do
    let(:user) { create(:user, id: 5, name: '佐々木武蔵', email: 'sasaki@example.com') }
    let(:lesson) { create(:lesson, name: '超実践型オンラインカバディ', description: 'カバディの基本的なルールについて') }
    let(:lesson_date) { create(:lesson_date, lesson: lesson) }
    let(:reservation) { create(:reservation, user: user, lesson_date: lesson_date) }

    before do
      create(:lesson_question_answer, reservation: reservation, question: 'Q1', answer: 'A1')
    end

    it '予約したユーザーの質問の回答内容を閲覧できること' do
      visit admins_lesson_lesson_date_path(lesson, lesson_date)

      expect(page).to have_selector 'h1', text: '超実践型オンラインカバディ'

      click_on '予約ユーザー一覧へ'

      expect(page).to have_selector 'h1', text: '予約しているユーザー一覧'
      expect(page).to have_content '佐々木武蔵'

      click_on '5'

      expect(page).to have_selector 'h1', text: '佐々木武蔵'
      expect(page).to have_content 'レッスン名: 超実践型オンラインカバディ'
      expect(page).to have_content 'レッスン詳細: カバディの基本的なルールについて'
      expect(page).to have_content '質問: Q1'
      expect(page).to have_content '回答: A1'
    end
  end
end
