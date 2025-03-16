class LessonQuestion < ApplicationRecord
  validates :content, presence: true

  belongs_to :lesson
end
