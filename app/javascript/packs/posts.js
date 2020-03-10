$(document).ready(function() {
  $(".instagram-card-input").on("keyup", function(event) {
    if ($(this).val() && event.keycode != 13)
      $(this)
        .parent()
        .find("input[type='submit']")
        .removeAttr("disabled");
    else
      $(this)
        .parent()
        .find("input[type='submit']")
        .attr("disabled", true);
  });
});
