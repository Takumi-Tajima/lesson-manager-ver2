require 'rails_helper'

RSpec.describe 'レッスンの機能', type: :system do
  let(:admin) { create(:admin) }

  before { sign_in admin }

  describe '一覧画面のデータ表示' do
    before { create(:lesson, id: 1, name: 'レッスンA') }

    it 'ヘッダーのリンクからレッスン一覧画面に遷移して、レッスンの一覧データを閲覧できること' do
      visit admins_instructors_path

      expect(page).to have_selector 'h1', text: '講師の一覧'

      within '.navbar' do
        click_on 'レッスン一覧'
      end

      expect(page).to have_selector 'h1', text: 'レッスン一覧'

      expect(page).to have_link '新しいレッスンを登録'
      expect(page).to have_content 'ID'
      expect(page).to have_content 'レッスン名'
      expect(page).to have_content '1'
      expect(page).to have_content 'レッスンA'
    end
  end

  describe '新規登録機能' do
    before { create(:instructor, name: '講師A') }

    it 'レッスンを新規登録することができること' do
      visit admins_lessons_path

      expect(page).to have_selector 'h1', text: 'レッスン一覧'

      click_on '新しいレッスンを登録'

      expect(page).to have_selector 'h1', text: 'レッスン新規登録'

      fill_in 'レッスン名', with: 'レッスンA'
      select '講師A', from: '講師'

      expect do
        click_on '登録する'
        expect(page).to have_content 'レッスンを登録しました'
      end.to change(Lesson, :count).by(1)

      expect(page).to have_selector 'h1', text: 'レッスン一覧'
      expect(page).to have_content 'レッスンA'
    end

    context '名前に何も入力されていない時' do
      it 'エラーメッセージが表示され、登録ができないこと' do
        visit admins_lessons_path

        expect(page).to have_selector 'h1', text: 'レッスン一覧'

        click_on '新しいレッスンを登録'

        expect(page).to have_selector 'h1', text: 'レッスン新規登録'

        fill_in 'レッスン名', with: ''
        select '講師A', from: '講師'

        expect do
          click_on '登録する'
        end.not_to change(Lesson, :count)

        expect(page).to have_selector 'h1', text: 'レッスン新規登録'
        expect(page).to have_content 'レッスン名を入力してください'
      end
    end
  end
end
