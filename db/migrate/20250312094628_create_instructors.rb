class CreateInstructors < ActiveRecord::Migration[8.0]
  def change
    create_table :instructors do |t|
      t.string :name, null: false, default: ''
      t.string :email, null: false, default: ''

      t.timestamps
      t.index :email, unique: true
    end
  end
end
