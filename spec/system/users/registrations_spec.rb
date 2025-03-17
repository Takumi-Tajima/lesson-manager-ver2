require 'rails_helper'

RSpec.describe 'ユーザーの登録', type: :system do
  it '新規登録をして、ログインができること' do
    visit root_path

    expect(page).to have_selector 'h1', text: 'レッスン一覧'

    within '.navbar' do
      click_on 'ログイン'
    end

    expect(page).to have_content 'ログイン'

    click_on '新規登録'

    expect(page).to have_selector 'h1', text: '新規登録'

    fill_in '名前',	with: 'taji'
    fill_in 'メールアドレス',	with: 'taji@example.com'
    fill_in 'パスワード',	with: 'password'
    fill_in 'パスワード（確認用）',	with: 'password'

    expect do
      click_on '登録する'
      expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
    end.to change(User, :count).by(1)

    email = open_last_email

    expect(email.subject).to eq 'メールアドレス確認メール'

    click_first_link_in_email(email)

    expect(page).to have_content 'メールアドレスが確認できました。'

    expect(page).to have_content 'ログイン'

    fill_in 'メールアドレス',	with: 'taji@example.com'
    fill_in 'パスワード',	with: 'password'

    within 'form' do
      click_on 'ログイン'
    end

    expect(page).to have_content 'ログインしました。'
    expect(page).to have_selector 'h1', text: 'レッスン一覧'

    within '.navbar' do
      expect(page).to have_button 'ログアウト'
      expect(page).to have_content 'taji@example.com'
    end
  end
end
