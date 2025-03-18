require 'rails_helper'

RSpec.describe 'レッスンの予約', type: :system do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '予約機能と予約の確認' do
    let(:instructor) { create(:instructor, name: '田島 匠') }
    let(:lesson) { create(:lesson, name: '英会話', instructor: instructor) }

    before do
      create(:lesson_date, start_at: '2025-03-20 09:00:00', end_at: '2025-03-20 12:00:00', lesson: lesson)
    end

    it '予約をして、予約した内容を一覧ページで確認できる' do
      visit lesson_path(lesson)

      expect(page).to have_selector 'h1', text: '英会話'
      expect(page).to have_selector 'h2', text: 'レッスンの開催日'

      expect do
        click_on '予約'
        expect(page).to have_content '予約を登録しました。'
      end.to change(user.reservations, :count).by(1)

      visit root_path

      expect(page).to have_selector 'h1', text: 'レッスン一覧'

      within '.navbar' do
        click_on '予約一覧'
      end

      expect(page).to have_selector 'h1', text: '予約一覧'
      expect(page).to have_content 'ID'
      expect(page).to have_content '講師'
      expect(page).to have_content '開始日時'
      expect(page).to have_content '終了日時'
      expect(page).to have_content '英会話'
      expect(page).to have_content '田島 匠'
      expect(page).to have_content '2025年03月20日(木) 09時00分'
      expect(page).to have_content '2025年03月20日(木) 12時00分'
    end

    context 'すでに同じ時間帯でレッスンを予約している場合' do
      before { create(:reservation, user: user, start_at: '2025-03-20 09:00:00', end_at: '2025-03-20 12:00:00') }

      it 'レッスンを予約できないこと' do
        visit lesson_path(lesson)

        expect(page).to have_selector 'h1', text: '英会話'
        expect(page).to have_selector 'h2', text: 'レッスンの開催日'

        expect do
          click_on '予約'
          expect(page).to have_content '予約に失敗しました。'
        end.not_to change(user.reservations, :count)

        within '.navbar' do
          click_on '予約一覧'
        end

        expect(page).to have_selector 'h1', text: '予約一覧'
        expect(page).not_to have_content '英会話'
        expect(page).not_to have_content '田島 匠'
      end
    end
  end

  describe '詳細画面のデータ表示' do
    let(:instructor) { create(:instructor, name: '田島 匠') }
    let(:lesson) { create(:lesson, name: '英会話', instructor: instructor) }
    let(:lesson_date) { create(:lesson_date, lesson: lesson) }

    before do
      create(:reservation, id: 1, user: user, lesson_date: lesson_date, lesson_name: '英会話', instructor_name: '田島 匠', lesson_description: '英会話のレッスンです',
                           start_at: '2025-03-20 09:00:00', end_at: '2025-03-20 12:00:00', url: 'https://example.com')
    end

    it '予約した内容を詳細ページで確認できる' do
      visit reservations_path

      expect(page).to have_selector 'h1', text: '予約一覧'

      expect(page).to have_content '1'
      expect(page).to have_content '英会話'
      expect(page).to have_content '田島 匠'
      expect(page).to have_content '2025年03月20日(木) 09時00分'
      expect(page).to have_content '2025年03月20日(木) 12時00分'

      click_on '1'

      expect(page).to have_selector 'h1', text: '英会話'
      expect(page).to have_content 'レッスン詳細: 英会話のレッスンです'
      expect(page).to have_content '講師: 田島 匠'
      expect(page).to have_content '開始日時: 2025年03月20日(木) 09時00分'
      expect(page).to have_content '終了日時: 2025年03月20日(木) 12時00分'
      expect(page).to have_content 'URL: https://example.com'
    end
  end

  describe '予約のキャンセル' do
    let(:lesson) { create(:lesson, name: 'オンラインボクシング') }
    let(:lesson_date) { create(:lesson_date, lesson: lesson, start_at: '2025-03-20 12:00:00', end_at: '2025-03-20 13:00:00') }

    before do
      create(:reservation, id: 8, user: user, lesson_date: lesson_date, lesson_name: 'オンラインボクシング')
    end

    it '予約をキャンセルができる' do
      visit reservations_path

      expect(page).to have_selector 'h1', text: '予約一覧'
      expect(page).to have_content 'オンラインボクシング'

      click_on '8'

      expect(page).to have_selector 'h1', text: 'オンラインボクシング'

      expect do
        accept_confirm do
          click_on 'キャンセル'
        end
        expect(page).to have_content '予約を削除しました。'
      end.to change(user.reservations, :count).by(-1)

      expect(page).to have_selector 'h1', text: '予約一覧'
      expect(page).to have_content '予約はありません'
      expect(page).not_to have_content 'オンラインボクシング'
    end
  end
end
