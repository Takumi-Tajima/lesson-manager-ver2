class Admins::Lessons::LessonDates::ReservationUsersController < Admins::ApplicationController
  def index
    @lesson = Lesson.find(params.expect(:lesson_id))
    @lesson_date = @lesson.lesson_dates.find(params.expect(:lesson_date_id))
    @users = @lesson_date.users.default_order
  end
end
