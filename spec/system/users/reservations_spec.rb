require 'rails_helper'

RSpec.describe 'レッスンの予約', type: :system do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '予約機能と予約の確認' do
    let(:instructor) { create(:instructor, name: '田島 匠') }
    let(:lesson) { create(:lesson, name: '英会話', instructor: instructor) }

    before do
      create(:lesson_date, start_at: Time.current + 1.hour, end_at: Time.current + 2.hours, lesson: lesson)
    end

    it '予約をして、予約した内容を予約一覧ページで確認できる' do
      visit lesson_path(lesson)

      expect(page).to have_selector 'h1', text: '英会話'
      expect(page).to have_selector 'h2', text: 'レッスンの開催日'

      click_on '予約'

      expect(page).to have_selector 'h1', text: '予約確認'
      expect(page).to have_content '英会話'
      expect(page).to have_content '講師: 田島 匠'
      expect(page).to have_selector 'h2', text: '質問事項'

      expect do
        click_on '予約する'
        expect(page).to have_content '予約を登録しました。'
      end.to change(user.reservations, :count).by(1)

      expect(page).to have_selector 'h1', text: '予約一覧'
      expect(page).to have_content '英会話'
      expect(page).to have_content '田島 匠'
    end

    context 'すでに同じ時間帯でレッスンを予約している場合' do
      before { create(:reservation, user: user, start_at: Time.current + 1.hour, end_at: Time.current + 2.hours) }

      it 'レッスンを予約できないこと' do
        visit lesson_path(lesson)

        expect(page).to have_selector 'h1', text: '英会話'
        expect(page).to have_selector 'h2', text: 'レッスンの開催日'

        click_on '予約'

        expect(page).to have_selector 'h1', text: '予約確認'
        expect(page).to have_content '英会話'

        expect do
          click_on '予約する'
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

    context '予約定員が満員の場合' do
      let(:lesson2) { create(:lesson, name: 'スペイン語') }
      let(:lesson_date) { create(:lesson_date, capacity: 1, lesson: lesson2) }

      before { create(:reservation, lesson_date: lesson_date) }

      it 'レッスンを予約できないこと' do
        visit lesson_path(lesson2)

        expect(page).to have_selector 'h1', text: 'スペイン語'
        expect(page).to have_selector 'h2', text: 'レッスンの開催日'
        expect(page).to have_content '満員'
      end
    end
  end

  describe '詳細画面のデータ表示' do
    let(:instructor) { create(:instructor, name: '田島 匠') }
    let(:lesson) { create(:lesson, name: '英会話', instructor: instructor) }
    let(:lesson_date) { create(:lesson_date, lesson: lesson) }

    before do
      create(:reservation, id: 1, user: user, lesson_date: lesson_date, lesson_name: '英会話', instructor_name: '田島 匠', lesson_description: '英会話のレッスンです', url: 'https://example.com')
    end

    it '予約した内容を詳細ページで確認できる' do
      visit reservations_path

      expect(page).to have_selector 'h1', text: '予約一覧'

      expect(page).to have_content '1'
      expect(page).to have_content '英会話'
      expect(page).to have_content '田島 匠'

      click_on '1'

      expect(page).to have_selector 'h1', text: '英会話'
      expect(page).to have_content 'レッスン詳細: 英会話のレッスンです'
      expect(page).to have_content '講師: 田島 匠'
      expect(page).to have_content 'URL: https://example.com'
    end
  end

  describe '過去に予約したレッスンの閲覧' do
    let(:lesson) { create(:lesson) }
    let(:lesson_date) { create(:lesson_date, lesson: lesson) }
    let(:reservation) { create(:reservation, id: 42, user: user, lesson_name: 'オンライン囲碁', lesson_date: lesson_date) }

    before { reservation.update(start_at: Time.current - 2.hours, end_at: Time.current - 1.hour) }

    it '過去のレッスン情報を閲覧することができる' do
      visit root_path

      expect(page).to have_selector 'h1', text: 'レッスン一覧'

      within '.navbar' do
        click_on '予約一覧'
      end

      expect(page).to have_selector 'h1', text: '予約一覧'
      expect(page).to have_content '予約はありません'
      expect(page).not_to have_content 'オンライン囲碁'

      visit root_path

      expect(page).to have_selector 'h1', text: 'レッスン一覧'

      within '.navbar' do
        click_on '予約履歴'
      end

      expect(page).to have_selector 'h1', text: '予約履歴一覧'
      expect(page).to have_content 'オンライン囲碁'

      click_on '42'

      expect(page).to have_selector 'h1', text: 'オンライン囲碁'
      expect(page).not_to have_button 'キャンセル'
      expect(page).not_to have_link '回答内容を編集する'
    end
  end

  describe '予約のキャンセル' do
    let(:lesson) { create(:lesson, name: 'オンラインボクシング') }
    let(:lesson_date) { create(:lesson_date, lesson: lesson) }

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
