class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable, :trackable, :confirmable

  has_many :reservations, dependent: :destroy

  scope :default_order, -> { order(:id) }

  def build_reservation(lesson_date)
    reservations.build(
      lesson_date: lesson_date,
      instructor_name: lesson_date.lesson.instructor.name,
      lesson_name: lesson_date.lesson.name,
      lesson_description: lesson_date.lesson.description,
      start_at: lesson_date.start_at,
      end_at: lesson_date.end_at,
      url: lesson_date.url
    )
  end
end
