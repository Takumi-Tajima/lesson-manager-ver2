class Reservation < ApplicationRecord
  belongs_to :lesson_date
  belongs_to :user
end
