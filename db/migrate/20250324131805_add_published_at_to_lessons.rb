class AddPublishedAtToLessons < ActiveRecord::Migration[8.0]
  def change
    add_column :lessons, :published_at, :datetime
  end
end
