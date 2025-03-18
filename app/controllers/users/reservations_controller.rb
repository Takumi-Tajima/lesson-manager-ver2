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

    reservation = current_user.build_reservation(lesson_date)

    if reservation.save
      redirect_to lesson_path(lesson), notice: t('controllers.common.created', model: '予約')
    else
      redirect_to lesson_path(lesson), alert: t('controllers.reservation.failed')
    end
  end

  def destroy
    current_user.reservations.find(params[:id]).destroy!
    redirect_to reservations_path, notice: t('controllers.common.destroyed', model: '予約')
  end
end
