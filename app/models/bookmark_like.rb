class BookmarkLike < ApplicationRecord
  enum type_action: {
    like: 0,
    bookmark: 1
  }

  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates :user_id, presence: true
  validates :likeable_id, presence: true
  validates :likeable_type, presence: true
  validates :type_action, presence: true
end
