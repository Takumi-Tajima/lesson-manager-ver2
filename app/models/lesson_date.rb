class LessonDate < ApplicationRecord
  validates :start_at, presence: true, comparison: { greater_than: Time.current }
  validates :end_at, presence: true, comparison: { greater_than: :start_at }
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :url, presence: true, format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/ }
  validate :validate_time_slot_uniqueness

  belongs_to :lesson

  scope :default_order, -> { order(:id) }

  private

  def validate_time_slot_uniqueness
    if lesson.lesson_dates.where.not(id: id).exists?(['start_at <= ? AND end_at >= ?', end_at, start_at])
      errors.add(:base, :validate_time_slot_uniqueness)
    end
  end
end
