class Admins::Lessons::LessonQuestionsController < Admins::ApplicationController
  before_action :set_lesson, only: %i[show new create edit update destroy]
  before_action :set_lesson_question, only: %i[show edit update destroy]

  def show
  end

  def new
    @lesson_question = LessonQuestion.new
  end

  def edit
  end

  def create
    @lesson_question = LessonQuestion.new(lesson_question_params)

    if @lesson_question.save
      redirect_to admins_lesson_lesson_question_path(@lesson, @lesson_question), notice: t('controllers.common.created', model: 'レッスンの質問')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @lesson_question.update(lesson_question_params)
      redirect_to admins_lesson_lesson_question_path(@lesson, @lesson_question), notice: t('controllers.common.updated', model: 'レッスンの質問'), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lesson_question.destroy!
    redirect_to admins_lesson_path(@lesson), notice: t('controllers.common.destroyed', model: 'レッスンの質問'), status: :see_other
  end

  private

  def set_lesson
    # TODO: 公開中のレッスンから引いてくる
    @lesson = Lesson.find(params.expect(:lesson_id))
  end

  def set_lesson_question
    @lesson_question = @lesson.lesson_questions.find(params.expect(:id))
  end

  def lesson_question_params
    params.expect(lesson_question: %i[lesson_id content])
  end
end
