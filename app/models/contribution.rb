class Contribution < ApplicationRecord

  belongs_to :post
  belongs_to :author
end
