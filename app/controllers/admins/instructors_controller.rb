class InstructorsController < ApplicationController
  before_action :set_instructor, only: %i[show edit update destroy]

  def index
    @instructors = Instructor.default_order
  end

  def show
  end

  def new
    @instructor = Instructor.new
  end

  def edit
  end

  def create
    @instructor = Instructor.new(instructor_params)

    if @instructor.save
      redirect_to @instructor, notice: t('controllers.common.created', model: '講師')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @instructor.update(instructor_params)
      redirect_to @instructor, notice: t('controllers.common.updated', model: '講師'), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @instructor.destroy!
    redirect_to instructors_path, notice: t('controllers.common.destroyed', model: '講師'), status: :see_other
  end

  private

  def set_instructor
    @instructor = Instructor.find(params.expect(:id))
  end

  def instructor_params
    params.expect(instructor: %i[name email])
  end
end
