class AddPasswordDigestToAuthors < ActiveRecord::Migration[5.0]
  def change
    add_column :authors, :password_digest, :string
  end
end
