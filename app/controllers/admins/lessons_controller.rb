class Admins::LessonsController < Admins::ApplicationController
  before_action :set_lesson, only: %i[ show edit update destroy ]

  def index
    @lessons = Lesson.all
  end

  def show
  end

  def new
    @lesson = Lesson.new
  end

  def edit
  end

  def create
    @lesson = Lesson.new(lesson_params)

    if @lesson.save
      redirect_to @lesson, notice: "Lesson was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @lesson.update(lesson_params)
      redirect_to @lesson, notice: "Lesson was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lesson.destroy!
    redirect_to lessons_path, notice: "Lesson was successfully destroyed.", status: :see_other
  end

  private
    def set_lesson
      @lesson = Lesson.find(params.expect(:id))
    end

    def lesson_params
      params.expect(lesson: [ :name, :description, :instructor_id ])
    end
end
