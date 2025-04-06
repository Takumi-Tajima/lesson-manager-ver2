require 'rails_helper'

RSpec.describe 'ユーザーの機能', type: :system do
  let(:admin) { create(:admin) }

  before do
    travel_to '2025-04-06 12:00:00'
    sign_in admin
    create(:user, id: 30, name: '田島匠', email: 'tajitaji@exmaple.com', last_sign_in_at: '2025-04-05 12:00:00', created_at: '2025-03-17 13:23:00')
    create(:user, name: '本田圭佑', email: 'honda@exmaple.com')
  end

  describe 'ユーザー情報のデータ表示' do
    it 'ユーザーの情報を閲覧できること' do
      visit admins_users_path

      expect(page).to have_selector 'h1', text: 'ユーザー一覧'

      expect(page).to have_content 'ユーザー名'
      expect(page).to have_content 'メールアドレス'
      expect(page).to have_content '田島匠'
      expect(page).to have_content 'tajitaji@exmaple.com'
      expect(page).to have_content '本田圭佑'
      expect(page).to have_content 'honda@exmaple.com'

      click_on '田島匠'

      expect(page).to have_selector 'h1', text: '田島匠'
      expect(page).to have_content 'メールアドレス: tajitaji@exmaple.com'
      expect(page).to have_content '最終ログイン日時: 2025年04月05日(土) 12時00分'
      expect(page).to have_content '登録日時: 2025年03月17日(月) 13時23分'
      expect(page).to have_content '更新日時: 2025年04月06日(日) 12時00分'
    end
  end
end
