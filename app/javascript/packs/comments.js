$(document).on("turbolinks:load", function() {
  $("body").on("click", "button.edit-comment", function() {
    var data_id = $(this).attr("data_id");
    var contentElement = $(this)
      .closest(".comment-text")
      .find(".comment-content");
    var content = $(contentElement)
      .clone()
      .children()
      .remove()
      .end()
      .text()
      .trim();
    $("#comment-content").val(content);

    $("#edit-submit")
      .unbind("click")
      .on("click", function() {
        content = $("#comment-content").val();
        $.ajax({
          type: "PATCH",
          url: "/comments/" + data_id,
          data: { comment: { content: content } },
          dataType: "script"
        });
      });
  });
});
