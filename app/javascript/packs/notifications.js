$(document).mouseup(function(e) {
  var container = $('div.notif');
  if (!container.is(e.target) && container.has(e.target).length === 0) {
    $('div.notif').removeClass('d-block');
  }
});
$(document).on('turbolinks:load',function() {
  $('div#notification_icon').on('click', function() {
    $('#count_unread_notif').hide();
    $('div.notif').toggleClass('d-block');
  });

  $('body').on('click', 'a.update_submit', function() {
    $(this)
      .parent()
      .find(".button_update_notif")
      .click();
    $(this).remove();
  });
  $('body').on('click', 'a.delete_submit', function() {
      $(this)
        .parent()
        .find('.button_delete_notif')
        .click();
    });
  $('a#mark_all_as_read')
    .unbind('click')
    .on('click', function() {
      $('.update_submit').click();
    });
});
