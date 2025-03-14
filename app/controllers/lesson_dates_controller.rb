class LessonDatesController < ApplicationController
  before_action :set_lesson_date, only: %i[ show edit update destroy ]

  # GET /lesson_dates
  def index
    @lesson_dates = LessonDate.all
  end

  # GET /lesson_dates/1
  def show
  end

  # GET /lesson_dates/new
  def new
    @lesson_date = LessonDate.new
  end

  # GET /lesson_dates/1/edit
  def edit
  end

  # POST /lesson_dates
  def create
    @lesson_date = LessonDate.new(lesson_date_params)

    if @lesson_date.save
      redirect_to @lesson_date, notice: "Lesson date was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lesson_dates/1
  def update
    if @lesson_date.update(lesson_date_params)
      redirect_to @lesson_date, notice: "Lesson date was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /lesson_dates/1
  def destroy
    @lesson_date.destroy!
    redirect_to lesson_dates_path, notice: "Lesson date was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson_date
      @lesson_date = LessonDate.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def lesson_date_params
      params.expect(lesson_date: [ :lesson_id, :start_at, :end_at, :capacity, :url ])
    end
end
