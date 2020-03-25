class NotificationPushService
  def initialize notif
    @current_user = notif[:sender]
    @receiver = notif[:receiver]
    @post = notif[:post]
    @type_notif = notif[:type_notif]
  end

  def push_notification
    new_notif = @current_user.active_notifications
                             .build receiver_id: @receiver.id,
                                    post_id: @post.blank? ? nil : @post.id,
                                    type_notif: @type_notif

    return unless new_notif.save

    ActionCable.server.broadcast "channel_user_#{@receiver.id}",
                                 notification: render_notif(new_notif),
                                 count: @receiver.passive_notifications
                                                 .unread
                                                 .size
  end

  def render_notif notif
    renderer = NotificationsController.renderer.new(http_host: Settings.host)
    renderer.render partial: "notifications/notification",
      locals: {notification: notif}
  end
end
