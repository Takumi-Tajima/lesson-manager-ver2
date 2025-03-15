class Admins::Lessons::LessonDatesController < Admins::ApplicationController
  before_action :set_lesson, only: %i[show new create]
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
      redirect_to @lesson_date, notice: t('controllers.common.created', model: 'レッスンの日時')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @lesson_date.update(lesson_date_params)
      redirect_to @lesson_date, notice: 'Lesson date was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lesson_date.destroy!
    redirect_to lesson_dates_path, notice: 'Lesson date was successfully destroyed.', status: :see_other
  end

  private

  def set_lesson
    # TODO: 公開中のレッスンから引いてくる
    @lesson = Lesson.find(params.expect(:lesson_id))
  end

  def set_lesson_date
    @lesson_date = @lesson.lesson_dates.find(params.expect(:id))
  end

  def lesson_date_params
    params.expect(lesson_date: %i[lesson_id start_at end_at capacity url])
  end
end
