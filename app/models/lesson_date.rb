class LessonDate < ApplicationRecord
  belongs_to :lesson

  scope :default_order, -> { order(:id) }
end
