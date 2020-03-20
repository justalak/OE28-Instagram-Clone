var loadData = require('packs/load_data');

$(document).ready(function() {
  var page = 1;
  var user_id = $('.user-profile').attr('data_id');
  var url = '/users/' + user_id + '/posts';
  loadData(url, { page: page });

  $(window).scroll(function() {
    if ($(window).scrollTop() == $(document).height() - $(window).height()) {
      page++;
      loadData(url, { page: page });
    }
  });
});
