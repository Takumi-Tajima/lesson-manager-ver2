class Reservation < ApplicationRecord
  belongs_to :lesson_date
  belongs_to :user

  validates :lesson_name, presence: true
  validates :instructor_name, presence: true
  validates :lesson_description, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
end
