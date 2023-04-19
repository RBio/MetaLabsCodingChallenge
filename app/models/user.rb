class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }
  has_secure_password

  after_create :create_user_cart

  has_one :cart
  has_many :purchases
  
  private

  def create_user_cart
    Cart.create(user_id: self.id)
  end
end
