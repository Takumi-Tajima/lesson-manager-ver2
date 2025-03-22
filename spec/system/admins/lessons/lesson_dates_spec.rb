require 'rails_helper'

RSpec.describe 'レッスンの日時', type: :system do
  let(:admin) { create(:admin) }

  before do
    sign_in admin
  end

  describe 'レッスンの日時の一覧データ表示' do
    let(:lesson) { create(:lesson, id: 1, name: 'オンライン空手') }

    context 'レッスンの日時が登録されている場合' do
      before do
        create(:lesson_date, id: 1, lesson: lesson, start_at: Time.current + 1.hour, end_at: Time.current + 3.hours, capacity: 5, url: 'https://www.example.com')
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

  describe 'レッスンの日時詳細データ表示' do
    let(:lesson) { create(:lesson, name: 'オンライン柔道') }

    before do
      create(:lesson_date, id: 25, lesson: lesson, start_at: Time.current + 1.hour, end_at: Time.current + 3.hours, capacity: 5, url: 'https://www.example.com')
    end

    it 'レッスンの日時の詳細データが表示されていること' do
      visit admins_lesson_path(lesson)

      expect(page).to have_selector 'h1', text: 'オンライン柔道'

      click_on '25'

      expect(page).to have_selector 'h1', text: 'オンライン柔道'
      expect(page).to have_content '開始日時:'
      expect(page).to have_content '終了日時:'
      expect(page).to have_content '定員: 5'
      expect(page).to have_content 'URL: https://www.example.com'
      expect(page).to have_link '編集'
      expect(page).to have_button '削除'
    end
  end

  describe '新規登録機能' do
    let(:lesson) { create(:lesson, name: 'ポルトガル語入門') }

    it 'レッスンの日時を新規登録することができること' do
      visit admins_lesson_path(lesson)

      expect(page).to have_selector 'h1', text: 'ポルトガル語入門'

      click_on '新しいレッスン日時を登録する'

      expect(page).to have_selector 'h1', text: '新規レッスン日時登録'

      start_time = Time.current + 30.minutes
      end_time = Time.current + 1.hour

      fill_in '開始日時', with: format_datetime_for_input(start_time)
      fill_in '終了日時', with: format_datetime_for_input(end_time)
      fill_in '定員', with: 1
      fill_in 'URL', with: 'https://www.example.test.com'

      expect do
        click_on '登録する'
        expect(page).to have_content 'レッスン日時を登録しました'
      end.to change(lesson.lesson_dates, :count).by(1)

      expect(page).to have_selector 'h1', text: 'ポルトガル語入門'
      expect(page).to have_content '開始日時:'
      expect(page).to have_content '終了日時:'
      expect(page).to have_content '定員: 1'
      expect(page).to have_content 'URL: https://www.example.test.com'
    end

    context '入力したないように不正な値があった場合' do
      it 'エラーメッセージが表示され、データが登録されないこと' do
        visit admins_lesson_path(lesson)

        expect(page).to have_selector 'h1', text: 'ポルトガル語入門'

        click_on '新しいレッスン日時を登録する'

        expect(page).to have_selector 'h1', text: '新規レッスン日時登録'

        past_time = Time.current - 1.minute
        earlier_end_time = Time.current - 2.hours

        fill_in '開始日時', with: format_datetime_for_input(past_time)
        fill_in '終了日時', with: format_datetime_for_input(earlier_end_time)
        fill_in '定員', with: 0
        fill_in 'URL', with: 'このURLに来てねー'

        expect do
          click_on '登録する'
        end.not_to change(lesson.lesson_dates, :count)

        expect(page).to have_selector 'h1', text: '新規レッスン日時登録'

        expect(page).to have_content '開始日時は現在時刻よりも先の日時を指定してください'
        expect(page).to have_content '終了日時は開始日時よりも先の日時を指定してください'
        expect(page).to have_content '定員は0より大きい値にしてください'
        expect(page).to have_content 'URLは不正な値です'
      end
    end
  end

  describe '編集機能' do
    let(:lesson) { create(:lesson, name: 'シュートフォーム改善') }

    before do
      create(:lesson_date, id: 30, lesson: lesson, start_at: Time.current + 30.minutes, end_at: Time.current + 1.hour, capacity: 8, url: 'https://www.example.football.com')
    end

    it 'レッスンの日時を編集することができること' do
      visit admins_lesson_path(lesson)

      expect(page).to have_selector 'h1', text: 'シュートフォーム改善'

      click_on '30'

      expect(page).to have_selector 'h1', text: 'シュートフォーム改善'
      expect(page).to have_content '開始日時:'
      expect(page).to have_content '終了日時:'
      expect(page).to have_content '定員: 8'
      expect(page).to have_content 'URL: https://www.example.football.com'

      click_on '編集'

      expect(page).to have_selector 'h1', text: 'レッスン日時の編集'

      future_start = Time.current + 3.days
      future_end = Time.current + 3.days + 4.hours

      fill_in '開始日時', with: format_datetime_for_input(future_start)
      fill_in '終了日時', with: format_datetime_for_input(future_end)
      fill_in '定員', with: 10
      fill_in 'URL', with: 'https://www.example.soccer.com'

      expect do
        click_on '更新する'
        expect(page).to have_content 'レッスン日時を編集しました。'
      end.not_to change(lesson.lesson_dates, :count)

      expect(page).to have_selector 'h1', text: 'シュートフォーム改善'
      expect(page).to have_content '定員: 10'
      expect(page).to have_content 'URL: https://www.example.soccer.com'
    end
  end

  describe '削除機能' do
    let(:lesson) { create(:lesson, name: '守備の極意') }

    before do
      create(:lesson_date, id: 30, lesson: lesson, start_at: Time.current + 30.minutes, end_at: Time.current + 1.hour)
    end

    it 'レッスンの日時を削除することができること' do
      visit admins_lesson_path(lesson)

      expect(page).to have_selector 'h1', text: '守備の極意'

      click_on '30'

      expect(page).to have_selector 'h1', text: '守備の極意'
      expect(page).to have_content '開始日時:'
      expect(page).to have_content '終了日時:'

      expect do
        accept_confirm do
          click_on '削除'
        end
        expect(page).to have_content 'レッスン日時を削除しました。'
      end.to change(lesson.lesson_dates, :count).by(-1)

      expect(page).to have_selector 'h1', text: '守備の極意'
      expect(page).to have_content 'レッスン日時が登録されていません'
      expect(page).not_to have_link '30'
    end
  end
end
