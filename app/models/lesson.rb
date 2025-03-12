class Lesson < ApplicationRecord
  belongs_to :instructor

  scope :default_order, -> { order(:id) }
end
