class LessonsController < ApplicationController
  def index
    @lessons = Lesson.published.default_order.preload(:instructor)
  end

  def show
    @lesson = Lesson.published.find(params.expect(:id))
  end
end
