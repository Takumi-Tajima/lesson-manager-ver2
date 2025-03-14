class Admins::Lessons::LessonDatesController < Admins::ApplicationController
  before_action :set_lesson_date, only: %i[show edit update destroy]

  def show
  end

  def new
    @lesson_date = LessonDate.new
  end

  def edit
  end

  def create
    @lesson_date = LessonDate.new(lesson_date_params)

    if @lesson_date.save
      redirect_to @lesson_date, notice: "Lesson date was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @lesson_date.update(lesson_date_params)
      redirect_to @lesson_date, notice: "Lesson date was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lesson_date.destroy!
    redirect_to lesson_dates_path, notice: "Lesson date was successfully destroyed.", status: :see_other
  end

  private
    def set_lesson_date
      @lesson_date = LessonDate.find(params.expect(:id))
    end

    def lesson_date_params
      params.expect(lesson_date: [ :lesson_id, :start_at, :end_at, :capacity, :url ])
    end
end
