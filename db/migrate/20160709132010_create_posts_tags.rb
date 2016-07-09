class CreatePostsTags < ActiveRecord::Migration[5.0]
  def change
    create_table :posts_tags do |t|

      t.references :post
      t.references :tag
      t.timestamps
    end
  end
end
