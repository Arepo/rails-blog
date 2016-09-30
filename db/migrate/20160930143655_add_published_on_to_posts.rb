class AddPublishedOnToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :published_on, :date
  end
end
