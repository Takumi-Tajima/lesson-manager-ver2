class Admins::Lessons::LessonDatesController < Admins::ApplicationController
  before_action :set_lesson, only: %i[show new create edit update destroy]
  before_action :set_lesson_date, only: %i[show edit update destroy]

  def show
  end

  def new
    @lesson_date = @lesson.lesson_dates.build
  end

  def edit
  end

  def create
    @lesson_date = @lesson.lesson_dates.build(lesson_date_params)

    if @lesson_date.save
      redirect_to admins_lesson_lesson_date_path(@lesson, @lesson_date), notice: t('controllers.common.created', model: 'レッスン日時')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @lesson_date.update(lesson_date_params)
      redirect_to admins_lesson_lesson_date_path(@lesson, @lesson_date), notice: t('controllers.common.updated', model: 'レッスン日時'), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lesson_date.destroy!
    redirect_to admins_lesson_path(@lesson), notice: t('controllers.common.destroyed', model: 'レッスン日時'), status: :see_other
  end

  private

  def set_lesson
    @lesson = Lesson.published.find(params.expect(:lesson_id))
  end

  def set_lesson_date
    @lesson_date = @lesson.lesson_dates.find(params.expect(:id))
  end

  def lesson_date_params
    params.expect(lesson_date: %i[lesson_id start_at end_at capacity url])
  end
end
