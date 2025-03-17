require 'rails_helper'

RSpec.describe 'ログイン', type: :system do
  let(:user) { create(:user, email: 'test@example.com') }

  before { sign_in user }

  context 'ログインしている時' do
    it 'ログアウトできること' do
      visit root_path

      expect(page).to have_content 'レッスン一覧'

      within '.navbar' do
        expect(page).to have_content 'test@example.com'
        click_on 'ログアウト'
      end
    end

    it 'ログイン画面に遷移できないこと' do
      visit root_path

      expect(page).to have_content 'レッスン一覧'

      visit new_user_session_path

      expect(page).to have_content 'レッスン一覧'
      expect(page).to have_content 'すでにログインしています。'
    end
  end
end
