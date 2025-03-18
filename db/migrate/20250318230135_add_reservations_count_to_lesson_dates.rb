class AddReservationsCountToLessonDates < ActiveRecord::Migration[8.0]
  def change
    add_column :lesson_dates, :reservations_count, :integer, null: false, default: 0
  end
end
