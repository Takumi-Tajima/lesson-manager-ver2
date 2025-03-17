class Users::ReservationsController < Users::ApplicationController
  def index
    @reservations = current_user.reservations.futures.order_by_start
  end

  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  def create
    lesson = Lesson.find(params.expect(:lesson_id))
    lesson_date = lesson.lesson_dates.find(params.expect(:lesson_date_id))

    current_user.create_reservation!(lesson_date)
    redirect_to lesson_path(lesson), notice: t('controllers.common.created', model: '予約')
  end
end
