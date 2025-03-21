class Users::ReservationsController < Users::ApplicationController
  def index
    @reservations = current_user.reservations.futures.order_by_start
  end

  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  def new
    lesson = Lesson.find(params[:lesson_id])
    lesson_date = LessonDate.find(params[:lesson_date_id])

    @reservation = current_user.build_reservation(lesson_date)

    lesson.lesson_questions.each do |question|
      @reservation.lesson_question_answers.build(question: question.content)
    end
  end

  def create
    reservation = current_user.reservations.build(reservation_params)

    if reservation.save
      redirect_to reservations_path, notice: t('controllers.common.created', model: '予約')
    else
      redirect_to reservations_path, alert: t('controllers.reservation.failed')
    end
  end

  def destroy
    current_user.reservations.find(params[:id]).destroy!
    redirect_to reservations_path, notice: t('controllers.common.destroyed', model: '予約')
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :lesson_date_id,
      :instructor_name,
      :lesson_name,
      :lesson_description,
      :start_at,
      :end_at,
      :url,
      lesson_question_answers_attributes: %i[question answer]
    )
    # TODO: expectを使用した定義方法にする
    # params.expect(
    #   reservation: [
    #     :lesson_date_id,
    #     :instructor_name,
    #     :lesson_name,
    #     :lesson_description,
    #     :start_at,
    #     :end_at,
    #     :url,
    #     { lesson_question_answers_attributes: %i[question answer] },
    #   ]
    # )
  end
end
