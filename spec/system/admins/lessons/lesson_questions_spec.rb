require 'rails_helper'

RSpec.describe 'レッスンの質問', type: :system do
  let(:admin) { create(:admin) }

  before do
    sign_in admin
  end

  describe 'レッスンの質問の一覧データ表示' do
    let(:lesson) { create(:lesson, id: 1, name: 'ジャマイカ語入門') }

    context 'レッスンの質問が登録されている場合' do
      before { create(:lesson_question, id: 20, lesson: lesson, content: 'これが質問である') }

      it 'レッスンの質問の一覧データが表示されていること' do
        visit admins_lessons_path

        expect(page).to have_selector 'h1', text: 'レッスン一覧'

        tr = find('tr', text: 'ジャマイカ語入門')

        within tr do
          click_on '1'
        end

        expect(page).to have_selector 'h1', text: 'ジャマイカ語入門'
        expect(page).to have_selector 'h2', text: 'レッスンの質問'
        expect(page).to have_content 'ID'
        expect(page).to have_content '質問内容'
        expect(page).to have_link '20'
        expect(page).to have_content 'これが質問である'
      end
    end

    context 'レッスンの質問が登録されていない場合' do
      it '質問が表示されないこと' do
        visit admins_lesson_path(lesson)

        expect(page).to have_selector 'h1', text: 'ジャマイカ語入門'
        expect(page).to have_selector 'h2', text: 'レッスンの質問'
        expect(page).to have_content '質問が登録されていません'
      end
    end
  end

  describe 'レッスンの質問詳細データ表示' do
    let(:lesson) { create(:lesson, name: 'オンライン柔道') }

    before { create(:lesson_question, id: 25, lesson: lesson, content: 'これが質問である') }

    it 'レッスンの質問の詳細データが表示されていること' do
      visit admins_lesson_path(lesson)

      expect(page).to have_selector 'h1', text: 'オンライン柔道'

      click_on '25'

      expect(page).to have_selector 'h1', text: 'オンライン柔道'
      expect(page).to have_content '質問の内容: これが質問である'
      expect(page).to have_link '編集'
      expect(page).to have_button '削除'
    end
  end

  describe '新規登録機能' do
    let(:lesson) { create(:lesson, name: 'ポルトガル語入門') }

    it 'レッスンの質問を新規登録することができること' do
      visit admins_lesson_path(lesson)

      expect(page).to have_selector 'h1', text: 'ポルトガル語入門'

      click_on '新しい質問を登録する'

      expect(page).to have_selector 'h1', text: 'レッスンの質問新規登録'

      fill_in '質問内容', with: 'これが質問である'

      expect do
        click_on '登録する'
        expect(page).to have_content 'レッスンの質問を登録しました'
      end.to change(lesson.lesson_questions, :count).by(1)

      expect(page).to have_selector 'h1', text: 'ポルトガル語入門'
      expect(page).to have_content '質問の内容: これが質問である'
    end

    context '入力したないように不正な値があった場合' do
      it 'エラーメッセージが表示され、データが登録されないこと' do
        visit admins_lesson_path(lesson)

        expect(page).to have_selector 'h1', text: 'ポルトガル語入門'

        click_on '新しい質問を登録する'

        expect(page).to have_selector 'h1', text: 'レッスンの質問新規登録'

        fill_in '質問内容', with: ''

        expect do
          click_on '登録する'
        end.not_to change(lesson.lesson_questions, :count)

        expect(page).to have_selector 'h1', text: 'レッスンの質問新規登録'
        expect(page).to have_content '質問内容を入力してください'
      end
    end
  end
end
