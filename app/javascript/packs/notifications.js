$(document).mouseup(function(e) {
  var container = $("div.notif");
  if (!container.is(e.target) && container.has(e.target).length === 0) {
    $("div.notif").removeClass("d-block");
  }
});
$(document).on("turbolinks:load", function() {
  $("div#notification_icon")
    .unbind("click")
    .on("click", function() {
      $("#count_unread_notif").hide();
      $("div.notif").toggleClass("d-block");
    });
  $("a.update_submit")
    .unbind("click")
    .on("click", function() {
      $(this)
        .parent()
        .find(".button_update_notif")
        .click();
      $(this).remove();
    });
  $("a.delete_submit")
    .unbind("click")
    .on("click", function() {
      $(this)
        .parent()
        .find(".button_delete_notif")
        .click();
    });
  $("a#mark_all_as_read")
    .unbind("click")
    .on("click", function() {
      $(".update_submit").click();
    });
});
