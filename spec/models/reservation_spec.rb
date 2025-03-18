require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:user) { create(:user) }

  describe 'validate_time_slot_uniquenessバリデーション' do
    before { travel_to '2025-03-15 09:00:00' }

    context '同じ時間帯に別レッスンがない場合' do
      it '予約を許可すること' do
        reservation = build(:reservation, user: user, start_at: '2025-03-15 09:00:00', end_at: '2025-03-15 13:00:00')
        expect(reservation).to be_valid
      end
    end

    context '同じ時間帯に別レッスンがある場合' do
      before do
        create(:reservation, user: user, start_at: '2025-03-15 10:00:00', end_at: '2025-03-15 12:00:00')
      end

      it '予約を許可しないこと' do
        reservation1 = build(:reservation, user: user, start_at: '2025-03-15 09:00:00', end_at: '2025-03-15 13:00:00')
        reservation2 = build(:reservation, user: user, start_at: '2025-03-15 08:00:00', end_at: '2025-03-15 11:00:00')
        reservation3 = build(:reservation, user: user, start_at: '2025-03-15 11:00:00', end_at: '2025-03-15 13:00:00')
        reservation4 = build(:reservation, user: user, start_at: '2025-03-15 10:30:00', end_at: '2025-03-15 11:30:00')

        expect(reservation1).not_to be_valid
        expect(reservation1.errors).to be_of_kind(:base, :validate_time_slot_uniqueness)

        expect(reservation2).not_to be_valid
        expect(reservation1.errors).to be_of_kind(:base, :validate_time_slot_uniqueness)

        expect(reservation3).not_to be_valid
        expect(reservation1.errors).to be_of_kind(:base, :validate_time_slot_uniqueness)

        expect(reservation4).not_to be_valid
        expect(reservation1.errors).to be_of_kind(:base, :validate_time_slot_uniqueness)
      end
    end
  end

  describe 'validate_capacityバリデーション' do
    let(:lesson_date) { create(:lesson_date, capacity: 2) }

    context '定員オーバーでない場合' do
      before { create(:reservation, lesson_date: lesson_date) }

      it '予約できること' do
        reservation = build(:reservation, lesson_date: lesson_date, user: user)
        expect(reservation).to be_valid
      end
    end

    context '定員オーバーの場合' do
      before { create_list(:reservation, 2, lesson_date: lesson_date) }

      it '予約を許可しないこと' do
        reservation = build(:reservation, lesson_date: lesson_date, user: user)
        expect(reservation).not_to be_valid
        expect(reservation.errors).to be_of_kind(:base, :validate_capacity)
      end
    end
  end
end
