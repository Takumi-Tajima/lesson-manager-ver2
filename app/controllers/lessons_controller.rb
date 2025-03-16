class LessonsController < ApplicationController
  def index
    # TODO: 公開中かつ開催日が未来のレッスンを取得する
    @lessons = Lesson.default_order.preload(:instructor)
  end

  def show
    # TODO: 公開中かつ開催日が未来のレッスンを取得する
    @lesson = Lesson.find(params.expect(:id))
  end
end
