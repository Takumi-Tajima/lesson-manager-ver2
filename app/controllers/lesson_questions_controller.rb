class LessonQuestionsController < ApplicationController
  before_action :set_lesson_question, only: %i[ show edit update destroy ]

  # GET /lesson_questions
  def index
    @lesson_questions = LessonQuestion.all
  end

  # GET /lesson_questions/1
  def show
  end

  # GET /lesson_questions/new
  def new
    @lesson_question = LessonQuestion.new
  end

  # GET /lesson_questions/1/edit
  def edit
  end

  # POST /lesson_questions
  def create
    @lesson_question = LessonQuestion.new(lesson_question_params)

    if @lesson_question.save
      redirect_to @lesson_question, notice: "Lesson question was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lesson_questions/1
  def update
    if @lesson_question.update(lesson_question_params)
      redirect_to @lesson_question, notice: "Lesson question was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /lesson_questions/1
  def destroy
    @lesson_question.destroy!
    redirect_to lesson_questions_path, notice: "Lesson question was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson_question
      @lesson_question = LessonQuestion.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def lesson_question_params
      params.expect(lesson_question: [ :lesson_id, :content ])
    end
end
