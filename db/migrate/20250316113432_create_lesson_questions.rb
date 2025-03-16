class CreateLessonQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :lesson_questions do |t|
      t.references :lesson, null: false, foreign_key: true
      t.string :content, null: false

      t.timestamps
    end
  end
end
