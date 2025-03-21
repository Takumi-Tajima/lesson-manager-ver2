class CreateLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :lessons do |t|
      t.string :name, null: false
      t.text :description
      t.references :instructor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
