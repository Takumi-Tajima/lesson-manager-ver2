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
      expect(page).to have_content '公開ステータス'
      expect(page).to have_content '1'
      expect(page).to have_content 'レッスンA'
      expect(page).to have_content '公開中'
    end
  end

  describe '詳細画面のデータ表示' do
    let(:instructor) { create(:instructor, name: '田島 匠') }

    before { create(:lesson, id: 1, name: 'レッスンA', description: 'レッスンAの詳細な説明', instructor: instructor) }

    it 'レッスンの詳細データを閲覧できること' do
      visit admins_lessons_path

      expect(page).to have_selector 'h1', text: 'レッスン一覧'

      tr = find('tr', text: 'レッスンA')

      within tr do
        click_on '1'
      end

      expect(page).to have_selector 'h1', text: 'レッスンA'
      expect(page).to have_content '公開ステータス: 公開中'
      expect(page).to have_content 'レッスン詳細: レッスンAの詳細な説明'
      expect(page).to have_content '講師: 田島 匠'
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

  describe '編集機能' do
    let(:instructor1) { create(:instructor, name: '吉田なおや') }
    let!(:instructor2) { create(:instructor, name: '佐々木健太郎') }

    before { create(:lesson, id: 1, name: 'スペイン語入門', description: 'スペイン語初心者へのオンラインレッスン', instructor: instructor1) }

    it 'レッスンを編集することができること' do
      visit admins_lessons_path

      expect(page).to have_selector 'h1', text: 'レッスン一覧'

      tr = find('tr', text: 'スペイン語入門')

      within tr do
        click_on '1'
      end

      expect(page).to have_selector 'h1', text: 'スペイン語入門'
      expect(page).to have_content 'レッスン詳細: スペイン語初心者へのオンラインレッスン'
      expect(page).to have_content '講師: 吉田なおや'

      click_on '編集'

      expect(page).to have_selector 'h1', text: 'レッスン編集'

      fill_in 'レッスン名', with: 'スペイン語マスター'
      fill_in '説明', with: '初心者から上級者まで対応するスペイン語コース'
      select '佐々木健太郎', from: '講師'

      expect do
        click_on '更新する'
        expect(page).to have_content 'レッスンを編集しました'
      end.not_to change(Lesson.find(1), :name)

      expect(page).to have_selector 'h1', text: 'スペイン語マスター'
      expect(page).to have_content 'レッスン詳細: 初心者から上級者まで対応するスペイン語コース'
      expect(page).to have_content '講師: 佐々木健太郎'
    end

    context '名前が空欄の場合' do
      it 'エラーメッセージが表示され、更新ができないこと' do
        visit admins_lessons_path

        expect(page).to have_selector 'h1', text: 'レッスン一覧'

        tr = find('tr', text: 'スペイン語入門')

        within tr do
          click_on '1'
        end

        expect(page).to have_selector 'h1', text: 'スペイン語入門'

        click_on '編集'

        expect(page).to have_selector 'h1', text: 'レッスン編集'

        fill_in 'レッスン名', with: ''

        expect do
          click_on '更新する'
        end.not_to change(Lesson.find(1), :name)

        expect(page).to have_selector 'h1', text: 'レッスン編集'
        expect(page).to have_content 'レッスン名を入力してください'
      end
    end
  end

  describe 'レッスンの公開' do
    context 'レッスンの説明欄が埋まっている場合' do
      before { create(:lesson, :unpublished, id: 4, name: 'スペイン語レッスン', description: 'スペイン語のレッスンです') }

      it 'レッスンを公開することができること' do
        visit admins_lessons_path

        expect(page).to have_selector 'h1', text: 'レッスン一覧'
        expect(page).to have_content 'スペイン語レッスン'
        expect(page).to have_content '非公開'

        find('tr', text: 'スペイン語レッスン').click_on '4'

        expect(page).to have_selector 'h1', text: 'スペイン語レッスン'
        expect(page).to have_content '公開ステータス: 非公開'

        click_on '編集'

        expect(page).to have_selector 'h1', text: 'レッスン編集'
        expect(page).to have_field 'レッスン名', with: 'スペイン語レッスン'
        expect(page).to have_field '説明', with: 'スペイン語のレッスンです'

        check '公開'
        click_on '更新する'

        expect(page).to have_content 'レッスンを編集しました'
        expect(page).to have_selector 'h1', text: 'スペイン語レッスン'
        expect(page).to have_content '公開ステータス: 公開中'
      end
    end

    context 'レッスンの説明欄が埋まってない場合' do
      before { create(:lesson, :unpublished, id: 4, name: '英語レッスン', description: '') }

      it 'レッスンを公開できないこと' do
        visit admins_lessons_path

        expect(page).to have_selector 'h1', text: 'レッスン一覧'
        expect(page).to have_content '英語レッスン'
        expect(page).to have_content '非公開'

        find('tr', text: '英語レッスン').click_on '4'

        expect(page).to have_selector 'h1', text: '英語レッスン'
        expect(page).to have_content '公開ステータス: 非公開'

        click_on '編集'

        expect(page).to have_selector 'h1', text: 'レッスン編集'
        expect(page).to have_field 'レッスン名', with: '英語レッスン'

        check '公開'
        click_on '更新する'

        expect(page).to have_content '公開するには、レッスンの説明を入力してください'
        expect(page).to have_selector 'h1', text: 'レッスン編集'
        expect(page).to have_field 'レッスン名', with: '英語レッスン'

        visit admins_lessons_path

        expect(page).to have_selector 'h1', text: 'レッスン一覧'
        expect(page).to have_content '英語レッスン'
        expect(page).to have_content '非公開'
      end
    end
  end

  describe '削除機能' do
    before { create(:lesson, id: 1, name: '英語レッスン') }

    it 'レッスンを削除することができること' do
      visit admins_lessons_path

      expect(page).to have_selector 'h1', text: 'レッスン一覧'
      expect(page).to have_content '英語レッスン'

      tr = find('tr', text: '英語レッスン')

      within tr do
        click_on '1'
      end

      expect(page).to have_selector 'h1', text: '英語レッスン'

      expect do
        accept_confirm do
          click_on '削除'
        end
        expect(page).to have_content 'レッスンを削除しました'
      end.to change(Lesson, :count).by(-1)

      expect(page).to have_selector 'h1', text: 'レッスン一覧'
      expect(page).not_to have_content '英語レッスン'
    end
  end
end
