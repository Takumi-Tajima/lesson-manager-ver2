class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.references :lesson_date, null: false, foreign_key: true, index: false
      t.references :user, null: false, foreign_key: true
      t.string :lesson_name, null: false
      t.string :instructor_name, null: false
      t.text :lesson_description, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.timestamps
      t.index %i[lesson_date_id user_id], unique: true
    end
  end
end
