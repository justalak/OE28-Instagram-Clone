class Notification < ApplicationRecord
  enum type_notif: {
    follow: 0,
    like: 1,
    comment: 2,
    reply: 3,
    like_comment: 4,
    mention: 5
  }
  enum status: {
    unread: 0,
    read: 1
  }

  belongs_to :sender, class_name: User.name
  belongs_to :receiver, class_name: User.name
  belongs_to :post, optional: true

  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  delegate :username, to: :sender, prefix: :sender

  scope :order_by_created_at, ->{order created_at: :desc}
end
