require 'rails_helper'

RSpec.describe 'ユーザーの機能', type: :system do
  let(:admin) { create(:admin) }

  before do
    sign_in admin
    create(:user, name: '田島匠', email: 'tajitaji@exmaple.com')
    create(:user, name: '本田圭佑', email: 'honda@exmaple.com')
  end

  describe 'ユーザー一覧機能' do
    it 'ユーザーの一覧データを閲覧できること' do
      visit admins_users_path

      expect(page).to have_selector 'h1', text: 'ユーザー一覧'

      expect(page).to have_content 'ID'
      expect(page).to have_content 'ユーザー名'
      expect(page).to have_content 'メールアドレス'
      expect(page).to have_content '田島匠'
      expect(page).to have_content 'tajitaji@exmaple.com'
      expect(page).to have_content '本田圭佑'
      expect(page).to have_content 'honda@exmaple.com'
    end
  end
end
