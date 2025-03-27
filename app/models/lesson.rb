class Lesson < ApplicationRecord
  include Publishable

  validates :name, presence: true
  validate :must_have_description_when_published

  belongs_to :instructor
  has_many :lesson_dates, dependent: :destroy
  has_many :lesson_questions, dependent: :destroy

  scope :default_order, -> { order(:id) }

  private

  def must_have_description_when_published
    if published.present? && description.blank?
      errors.add(:published, :must_have_description_when_published)
    end
  end
end
