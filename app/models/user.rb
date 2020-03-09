class User < ApplicationRecord
  include UserConcern
  
  attr_accessor :remember_token
  enum gender: {female: 0, male: 1, other: 2}
  enum role: {user: 0, admin: 1}

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
  validates :password, presence: true,
    length: {minimum: Settings.user.min_length_password}, allow_nil: true

  before_save :downcase_email

  has_secure_password
  has_one_attached :avatar_image

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
    return false unless digest and token

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
