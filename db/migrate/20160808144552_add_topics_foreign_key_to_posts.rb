class AddTopicsForeignKeyToPosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :topic
  end
end
