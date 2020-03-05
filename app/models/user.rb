class User < ApplicationRecord
  include UserConcern

  attr_accessor :remember_token
  enum gender: {female: 0, male: 1, other: 2}
  enum role: {user: 0, admin: 1}

  has_many :posts, dependent: :destroy
  validates :name, presence: true,
    length: {maximum: Settings.user.max_length_name}
  validates :email, presence: true,
    length: {maximum: Settings.user.max_length_email},
    format: {with: Settings.user.email_regex},
    uniqueness: {case_sensitive: true}
  validates :username, presence: true,
    length: {
      maximum: Settings.user.max_length_username,
      minimum: Settings.user.min_length_username
    },
    format: {with: Settings.user.username_regex},
    uniqueness: {case_sensitive: true}
  validates :phone, allow_blank: true,
    format: {with: Settings.user.phone_regex}
  validates :website, allow_blank: true,
    format: {with: Settings.user.website_regex}
  validates :password, presence: true,
    length: {minimum: Settings.user.min_length_password}, allow_nil: true

  before_save :downcase_email

  has_secure_password
  has_one_attached :avatar_image
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships

  USER_PARAMS = %i(email name username password password_confirmation).freeze
  USER_PARAMS_UPDATE = %i(email name username website
                          bio phone gender avatar_image).freeze

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticate? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest && token

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update remember_digest: nil
  end

  private
  
  def downcase_email
    email.downcase!
  end
end
