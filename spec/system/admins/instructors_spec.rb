require 'rails_helper'

RSpec.describe '講師の機能', type: :system do
  let(:admin) { create(:admin) }

  before { sign_in admin }

  describe '一覧画面のデータ表示' do
    before { create(:instructor, name: '講師太郎', email: 'instructor@example.com') }

    it 'トップページから講師一覧に遷移して、講師の一覧データを閲覧できること' do
      visit admins_root_path

      # TODO: レッスン作成時に、レッスンの一覧ページをルートに設定する
      # expect(page).to have_selector 'h1', text: 'レッスン一覧'

      within '.navbar' do
        click_on '講師一覧'
      end

      expect(page).to have_selector 'h1', text: '講師の一覧'
      expect(page).to have_link '新規講師の登録'
      expect(page).to have_content '名前'
      expect(page).to have_content 'メールアドレス'
      expect(page).to have_content '講師太郎'
      expect(page).to have_content 'instructor@example.com'
    end
  end

  describe '新規登録機能' do
    it '新規講師の登録ができること' do
      visit admins_instructors_path

      expect(page).to have_selector 'h1', text: '講師の一覧'

      click_on '新規講師の登録'

      expect(page).to have_selector 'h1', text: '講師の新規登録'

      fill_in '名前', with: '講師太郎'
      fill_in 'メールアドレス', with: 'instructor@example.com'

      expect do
        click_on '登録する'
        expect(page).to have_content '講師を登録しました'
      end.to change(Instructor, :count).by(1)

      expect(page).to have_selector 'h1', text: '講師の一覧'

      expect(page).to have_content '講師太郎'
      expect(page).to have_content 'instructor@example.com'
    end

    context 'すでに同じメールアドレスが登録されている場合' do
      before { create(:instructor, email: 'instructor@example.com') }

      it 'エラーメッセージが表示され、登録ができないこと' do
        visit admins_instructors_path

        expect(page).to have_selector 'h1', text: '講師の一覧'

        click_on '新規講師の登録'

        expect(page).to have_selector 'h1', text: '講師の新規登録'

        fill_in '名前', with: '講師太郎'
        fill_in 'メールアドレス', with: 'instructor@example.com'

        expect do
          click_on '登録する'
        end.not_to change(Instructor, :count)

        expect(page).to have_selector 'h1', text: '講師の新規登録'
        expect(page).to have_content 'メールアドレスはすでに存在します'
      end
    end
  end

  describe '編集機能' do
    before { create(:instructor, name: '講師太郎', email: 'instructor@example.com') }

    it '講師の情報を編集できること' do
      visit admins_instructors_path

      expect(page).to have_selector 'h1', text: '講師の一覧'
      expect(page).to have_content '講師太郎'
      expect(page).to have_content 'instructor@example.com'

      tr = find('tr', text: '講師太郎')

      within tr do
        click_on '編集'
      end

      expect(page).to have_selector 'h1', text: '講師の編集'

      fill_in '名前', with: '高橋ジョージ'
      fill_in 'メールアドレス', with: 'takahashi@example.com'

      expect do
        click_on '更新する'
        expect(page).to have_content '講師を編集しました'
      end.not_to change(Instructor, :count)

      expect(page).to have_selector 'h1', text: '講師の一覧'
      expect(page).to have_content '高橋ジョージ'
      expect(page).to have_content 'takahashi@example.com'
    end
  end

  describe '削除機能' do
    before { create(:instructor, name: '講師太郎', email: 'instructor@example.com') }

    it '講師を削除できること' do
      visit admins_instructors_path

      expect(page).to have_selector 'h1', text: '講師の一覧'
      expect(page).to have_content '講師太郎'
      expect(page).to have_content 'instructor@example.com'

      expect do
        accept_confirm do
          click_on '削除'
        end
        expect(page).to have_content '講師を削除しました'
      end.to change(Instructor, :count).by(-1)

      expect(page).to have_selector 'h1', text: '講師の一覧'
      expect(page).not_to have_content '講師太郎'
      expect(page).not_to have_content 'instructor@example.com'
    end
  end
end
