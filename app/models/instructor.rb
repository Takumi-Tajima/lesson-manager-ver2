class Instructor < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :lessons, dependent: :destroy

  scope :default_order, -> { order(:id) }
end
