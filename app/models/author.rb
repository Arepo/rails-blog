class Author < ApplicationRecord

  has_many :contributions, dependent: :destroy
  has_many :posts, through: :contributions

  validates :email, :name, presence: true

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
