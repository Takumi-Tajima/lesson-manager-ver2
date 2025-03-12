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
end
