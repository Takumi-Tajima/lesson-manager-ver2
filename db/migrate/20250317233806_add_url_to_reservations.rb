class AddUrlToReservations < ActiveRecord::Migration[8.0]
  def change
    add_column :reservations, :url, :string, null: false, default: ''
  end
end
