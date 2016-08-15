class AddRememberDigestToAuthors < ActiveRecord::Migration[5.0]
  def change
    add_column :authors, :remember_digest, :string
  end
end
