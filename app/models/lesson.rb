class Lesson < ApplicationRecord
  validates :name, presence: true

  belongs_to :instructor
  has_many :lesson_dates, dependent: :destroy
  has_many :lesson_questions, dependent: :destroy

  scope :default_order, -> { order(:id) }
end
