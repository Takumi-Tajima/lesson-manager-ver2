require 'rails_helper'

RSpec.describe 'レッスンの日時', type: :system do
  let(:admin) { create(:admin) }

  before { sign_in admin }

  describe 'レッスンの日時の一覧' do
    let(:lesson) { create(:lesson, id: 1, name: 'オンライン空手') }

    context 'レッスンの日時が登録されている場合' do
      before do
        create(:lesson_date, id: 1, lesson: lesson, start_at: '2025-03-15 10:00:00', end_at: '2025-03-15 12:00:00', capacity: 5, url: 'https://www.example.com')
        travel_to '2025-03-15 09:00:00'
      end

      it 'レッスンの日時の一覧データが表示されていること' do
        visit admins_lessons_path

        expect(page).to have_selector 'h1', text: 'レッスン一覧'

        tr = find('tr', text: 'オンライン空手')

        within tr do
          click_on '1'
        end

        expect(page).to have_selector 'h1', text: 'オンライン空手'
        expect(page).to have_selector 'h2', text: 'レッスン日時'
        expect(page).to have_content 'ID'
        expect(page).to have_content '開始日時'
        expect(page).to have_content '終了日時'
        # TODO: 予約機能実装時にコメントアウトを外す
        # expect(page).to have_content '予約人数'
        expect(page).to have_content '募集人数'
        expect(page).to have_link '1'
        expect(page).to have_content '2025年03月15日(土) 10時00分'
        expect(page).to have_content '2025年03月15日(土) 12時00分'
        expect(page).to have_content '5'
      end
    end

    context 'レッスンの日時が登録されていない場合' do
      it '日時が表示されないこと' do
        visit admins_lesson_path(lesson)

        expect(page).to have_selector 'h1', text: 'オンライン空手'
        expect(page).to have_selector 'h2', text: 'レッスン日時'
        expect(page).to have_content 'レッスン日時が登録されていません'
      end
    end
  end
end
