class CreateLessonDates < ActiveRecord::Migration[8.0]
  def change
    create_table :lesson_dates do |t|
      t.references :lesson, null: false, foreign_key: true
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.integer :capacity, null: false, default: 1
      t.string :url, null: false

      t.timestamps
    end
  end
end
