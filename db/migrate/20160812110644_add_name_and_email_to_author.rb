class AddNameAndEmailToAuthor < ActiveRecord::Migration[5.0]
  def change
    add_column :authors, :name, :text
    add_column :authors, :email, :text
  end
end
