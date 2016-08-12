class Author < ApplicationRecord

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  has_secure_password

  has_many :contributions, dependent: :destroy
  has_many :posts, through: :contributions

  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: {
                              with: EMAIL_REGEX,
                              message: 'Your email is bad and you should feel bad'
                            }

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
