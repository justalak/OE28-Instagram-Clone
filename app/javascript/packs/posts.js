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

  $('.reply button').on('click', function(){
    var parent_id = $(this).attr('comment_id');
    var postElement= $(this).closest('.instagram-card');
    $('#comment_parent_id').val(parent_id)
    $(postElement).find('#comment_content').focus()
  })
});
