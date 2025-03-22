class Users::Reservations::LessonQuestionAnswersController < Users::ApplicationController
  before_action :set_reservation, only: %i[edit update]

  def edit
  end

  def update
    if @reservation.update(lesson_question_answer_params)
      redirect_to reservation_path(@reservation), notice: t('controllers.common.updated', model: '回答内容')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_reservation
    @reservation = current_user.reservations.find(params.expect(:reservation_id))
  end

  def lesson_question_answer_params
    params.require(:reservation).permit(
      lesson_question_answers_attributes: %i[id answer]
    )
  end
end
