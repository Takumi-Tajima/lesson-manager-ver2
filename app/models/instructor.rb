class Instructor < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  scope :default_order, -> { order(:id) }
end
