class AddTitleAndBodyToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :title, :text
    add_column :posts, :body, :string
  end
end
