class BookmarkLike < ApplicationRecord
  enum type_action: {
    like: 0,
    bookmark: 1
  }

  belongs_to :user
  belongs_to :post

  validates :user_id, presence: true
  validates :post_id, presence: true
end
