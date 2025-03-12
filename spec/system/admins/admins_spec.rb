require 'rails_helper'

RSpec.describe '管理者ログイン機能', type: :system do
  let!(:admin) { create(:admin, email: 'admin@example.com', password: 'password') }

  it '管理者は管理画面からログインできる' do
    visit new_admin_session_path

    expect(page).to have_selector 'h1', text: '管理者：ログイン'

    fill_in 'メールアドレス',	with: 'admin@example.com'
    fill_in 'パスワード',	with: 'password'
    click_button 'ログイン'

    within '.navbar' do
      expect(page).to have_link '管理者: LessonManager'
      expect(page).to have_content 'admin@example.com'
      expect(page).to have_button 'ログアウト'
    end

    # TODO: レッスンのCRUD操作時に実装をする
    # expect(page).to have_selector 'h1', text: 'レッスン一覧'
  end

  context 'すでにログインしている時' do
    before { sign_in admin }

    it '管理者はログイン後は、ログイン画面にアクセスできない' do
      visit new_admin_session_path

      expect(page).to have_content 'すでにログインしています'
      expect(page).to have_current_path admins_root_path
    end

    it '管理者は管理者トップページからログアウトできる' do
      visit admins_root_path

      within '.navbar' do
        click_button 'ログアウト'
      end

      expect(page).to have_content 'ログアウトしました'
      expect(page).not_to have_button 'ログアウト'
      expect(page).to have_current_path new_admin_session_path
    end
  end
end
