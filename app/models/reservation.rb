class Reservation < ApplicationRecord
  belongs_to :lesson_date, counter_cache: true
  belongs_to :user
  has_many :lesson_question_answers, dependent: :destroy

  accepts_nested_attributes_for :lesson_question_answers

  validates :lesson_name, presence: true
  validates :instructor_name, presence: true
  validates :lesson_description, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :user_id, uniqueness: { scope: :lesson_date_id }
  validate :validate_time_slot_uniqueness
  validate :validate_capacity

  scope :default_order, -> { order(:id) }
  scope :futures, -> { where('start_at > ?', Time.current) }
  scope :order_by_start, -> { order(:start_at) }

  private

  def validate_time_slot_uniqueness
    if user.reservations.where.not(id: id).exists?(['start_at <= ? AND end_at >= ?', end_at, start_at])
      errors.add(:base, :validate_time_slot_uniqueness)
    end
  end

  def validate_capacity
    if lesson_date.capacity <= lesson_date.reservations.where.not(id: id).count
      errors.add(:base, :validate_capacity)
    end
  end
end
