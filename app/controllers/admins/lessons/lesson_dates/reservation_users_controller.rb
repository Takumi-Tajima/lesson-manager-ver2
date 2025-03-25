class Admins::Lessons::LessonDates::ReservationUsersController < Admins::ApplicationController
  before_action :set_lesson
  before_action :set_lesson_date

  def index
    @users = @lesson_date.users.default_order
  end

  def show
    reservation = @lesson_date.reservations.find_by(user_id: params.expect(:id))
    @lesson_question_answers = reservation.lesson_question_answers.default_order
    @user = reservation.user
  end

  private

  def set_lesson
    @lesson = Lesson.published.find(params.expect(:lesson_id))
  end

  def set_lesson_date
    @lesson_date = @lesson.lesson_dates.find(params.expect(:lesson_date_id))
  end
end
