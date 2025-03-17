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

      tr = find('tr', text: '2025年03月20日(木) 09時00分')

      within tr do
        expect do
          click_on '予約する'
          expect(page).to have_content '予約を登録しました。'
        end.to chnage(user.reservations, :count).by(1)
      end

      visit root_path

      expect(page).to have_selector 'h1', text: 'レッスン一覧'

      within '.nav' do
        click_on '予約一覧'
      end

      expect(page).to have_selector 'h1', text: '予約一覧'
      expect(page).to have_content '英会話'
      expect(page).to have_content '田島 匠'
      expect(page).to have_content '2025年03月20日(木) 09時00分'
      expect(page).to have_content '2025年03月20日(木) 12時00分'
    end
  end
end
