$(document).on("turbolinks:load", function () {
  function readURL(input) {
    if (input.files) {
      var filesAmount = input.files.length;
      for (i = 0; i < filesAmount; i++) {
        var reader = new FileReader();
        reader.onload = function (e) {
          $("#upload-preview").append('<img class="image-preview" src="' + e.target.result + '" />');
        };
        reader.readAsDataURL(input.files[i]);
      }
    }
  }

  $('#new_post input[type="file"]').change(function () {
    $("#upload-preview").empty();
    readURL(this);
  });

  $('#user-avatar-image-6').change(function(){
    if (this.files && this.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('.form-edit-user .avatar').attr('src', e.target.result);
      };
      reader.readAsDataURL(this.files[0]);
    }
  })
});
