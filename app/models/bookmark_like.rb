class BookmarkLike < ApplicationRecord
  enum type_action: {
    like: 0,
    bookmark: 1
  }

  validates :user_id, presence: true
  validates :post_id, presence: true

  belongs_to :user
  belongs_to :post

  scope :likers_user, (lambda do |post_id|
    select(:user_id).where(post_id: post_id, type_action: 0)
  end)
  scope :bookmarking_post, (lambda do |user_id|
    select(:post_id).where(user_id: user_id, type_action: 1)
  end)
end
