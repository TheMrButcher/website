class Private::User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:finders]
  
  VALID_NAME = /\A[a-z0-9_]+\z/i
  validates :name,
    presence: true,
    length: { maximum: 30 },
    format: { with: VALID_NAME },
    uniqueness: true
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  
  validates :password, presence: true, length: { minimum: 8, maximum: 30 }
  
  has_many :folders, foreign_key: "owner_id"
  
  has_secure_password
  
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
