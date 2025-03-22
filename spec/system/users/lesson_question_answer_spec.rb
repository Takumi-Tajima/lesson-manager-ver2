require 'rails_helper'

RSpec.describe 'レッスンの質問と回答', type: :system do
  let(:user) { create(:user) }
  let(:lesson) { create(:lesson, name: 'オンライン剣道') }

  before do
    create(:lesson_date, id: 18, lesson: lesson)
    create(:lesson_question, lesson: lesson, content: '剣道の経験はありますか？')
    sign_in user
  end

  it 'レッスン予約時にレッスンの質問に回答でき、詳細画面から回答内容を閲覧できること' do
    visit root_path

    expect(page).to have_selector 'h1', text: 'レッスン一覧'

    click_on 'オンライン剣道'

    expect(page).to have_selector 'h1', text: 'オンライン剣道'
    expect(page).to have_selector 'h2', text: 'レッスンの開催日'

    within '.container' do
      click_on '予約'
    end

    expect(page).to have_selector 'h1', text: '予約確認'
    expect(page).to have_content 'オンライン剣道'

    fill_in '剣道の経験はありますか？', with: 'あります'

    expect do
      click_on '予約する'
      expect(page).to have_content '予約を登録しました。'
    end.to change(user.reservations, :count).by(1)

    expect(page).to have_selector 'h1', text: '予約一覧'

    tr = find('tr', text: 'オンライン剣道')

    within tr do
      first('a').click
    end

    expect(page).to have_selector 'h1', text: 'オンライン剣道'
    expect(page).to have_selector 'h2', text: 'レッスンの事前質問'
    expect(page).to have_content '質問: 剣道の経験はありますか？'
    expect(page).to have_content '回答: あります'
  end

  describe '回答内容の編集' do
    let(:reservation) { create(:reservation, user: user, lesson_name: '最強のマーケティング講座') }

    before { create(:lesson_question_answer, reservation: reservation, question: 'マーケティングの経験はありますか？', answer: 'ありません') }

    it 'レッスンの回答内容を編集できること' do
      visit reservation_path(reservation)

      expect(page).to have_selector 'h1', text: '最強のマーケティング講座'
      expect(page).to have_selector 'h2', text: 'レッスンの事前質問'
      expect(page).to have_content '質問: マーケティングの経験はありますか？'
      expect(page).to have_content '回答: ありません'

      click_on '回答内容を編集する'

      expect(page).to have_selector 'h1', text: 'レッスン事前質問'
      expect(page).to have_field 'マーケティングの経験はありますか？', with: 'ありません'

      fill_in 'マーケティングの経験はありますか？', with: '少しだけあります'

      expect do
        click_on '更新する'
        expect(page).to have_content '回答内容を編集しました。'
      end.not_to change(reservation.lesson_question_answers, :count)

      expect(page).to have_selector 'h1', text: '最強のマーケティング講座'
      expect(page).to have_selector 'h2', text: 'レッスンの事前質問'
      expect(page).to have_content '質問: マーケティングの経験はありますか？'
      expect(page).to have_content '回答: 少しだけあります'
    end
  end
end
