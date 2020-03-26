class Notification < ApplicationRecord
  ABOUT_POST_TYPE = %i(like comment reply mention like_comment).freeze
  FOLLOW_REQUEST_TYPE = %i(follow request accept).freeze

  enum type_notif: {
    follow: 0,
    like: 1,
    comment: 2,
    reply: 3,
    like_comment: 4,
    mention: 5,
    request: 6,
    accept: 7
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
  scope :get_by_all, (lambda do |sender_id, receiver_id, type_notif|
    where(sender_id: sender_id, receiver_id: receiver_id, type_notif: type_notif)
  end)
  scope :about_post, (lambda do
    where(type_notif: ABOUT_POST_TYPE)
  end)
  scope :follow_request, (lambda do
    where(type_notif: FOLLOW_REQUEST_TYPE)
  end)
end
