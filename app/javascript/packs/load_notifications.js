var loadData = require('packs/load_data');

$(document).on('turbolinks:load', function() {
  var page = 1;
  var url = '/notifications';
  var type = $('#type-notifications').val();

  $('#type-notifications')
    .unbind('change')
    .on('change', function() {
    type = $(this).val();
    page = 1;
    $('#frame-notification').empty();
    loadData(url, { page: page, type: type });
  });

  $('#load-notifications')
    .unbind('click')
    .on('click', function() {
      page++;
      loadData(url, { page: page, type: type });
    });
});
