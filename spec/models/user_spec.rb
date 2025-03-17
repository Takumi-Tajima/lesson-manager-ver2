require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'create_reservation!()' do
    let(:user) { create(:user) }
    let(:lesson) { create(:lesson) }

    before { create(:lesson_date, lesson: lesson) }

    it '予約が作成できること' do
      reservation = user.create_reservation!(lesson.lesson_dates.first)
      expect(reservation).to be_persisted
    end
  end
end
