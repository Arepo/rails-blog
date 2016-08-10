class AddNameToTags < ActiveRecord::Migration[5.0]
  def change
    add_column :tags, :name, :text, default: ""
  end
end
