import consumer from './consumer';

consumer.subscriptions.create('RoomChannel', {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('#count_unread_notif').show();
    $('#count_unread_notif').text(data.count);
    $('#frame-notification').prepend(data.notification);
  }
});
