class Lesson < ApplicationRecord
  validates :name, presence: true

  belongs_to :instructor

  scope :default_order, -> { order(:id) }
end
