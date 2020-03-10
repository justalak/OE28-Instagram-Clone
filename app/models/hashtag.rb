class Hashtag < ApplicationRecord
  has_many :post_hashtags, dependent: :destroy
  has_many :posts, through: :post_hashtags

  validates :name, presence: true,
    length: {maximum: Settings.hashtag.max_length},
    uniqueness: {case_sensitive: false}
end
