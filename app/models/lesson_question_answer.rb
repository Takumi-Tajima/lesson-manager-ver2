class LessonQuestionAnswer < ApplicationRecord
  belongs_to :reservation

  scope :default_order, -> { order(:id) }
end
