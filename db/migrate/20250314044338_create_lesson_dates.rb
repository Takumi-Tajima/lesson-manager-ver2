class CreateLessonDates < ActiveRecord::Migration[8.0]
  def change
    create_table :lesson_dates do |t|
      t.references :lesson, null: false, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :capacity
      t.string :url

      t.timestamps
    end
  end
end
