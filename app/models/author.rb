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

  attr_accessor :remember_token

  def remember
    self.remember_token = self.class.new_token
    update remember_digest: self.class.digest(remember_token)
  end

  def forget
    update remember_digest: nil
  end

  def authenticated? remember_token
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

####

  private

  def downcase_email
    self.email.downcase!
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end

    BCrypt::Password.create string, cost: cost
  end
end
