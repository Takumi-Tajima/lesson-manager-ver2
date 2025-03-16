class LessonQuestion < ApplicationRecord
  validates :content, presence: true

  belongs_to :lesson

  scope :default_order, -> { order(:id) }
end
