class PushWorker
  include Sidekiq::Worker

  def perform notif_hash
    notif = {
      sender: User.find_by(id: notif_hash["sender_id"]),
      receiver: User.find_by(id: notif_hash["receiver_id"]),
      post_id: notif_hash["post_id"],
      type_notif: notif_hash["type_notif"]
    }
    NotificationPushService.new(notif).push_notification
  end
end
