class CreateContributions < ActiveRecord::Migration[5.0]
  def change
    create_table :contributions do |t|

      t.references :post
      t.references :author
      t.timestamps
    end
  end
end
