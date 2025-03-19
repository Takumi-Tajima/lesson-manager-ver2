class CreateLessonQuestionAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :lesson_question_answers do |t|
      t.references :reservation, null: false, foreign_key: true
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
