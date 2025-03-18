class Reservation < ApplicationRecord
  belongs_to :lesson_date
  belongs_to :user

  validates :lesson_name, presence: true
  validates :instructor_name, presence: true
  validates :lesson_description, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :user_id, uniqueness: { scope: :lesson_date_id }
  validate :validate_time_slot_uniqueness

  scope :default_order, -> { order(:id) }
  scope :futures, -> { where('start_at > ?', Time.current) }
  scope :order_by_start, -> { order(:start_at) }

  private

  def validate_time_slot_uniqueness
    if user.reservations.where.not(id: id).exists?(['start_at <= ? AND end_at >= ?', end_at, start_at])
      errors.add(:base, :validate_time_slot_uniqueness)
    end
  end
end
