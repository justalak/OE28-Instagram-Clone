var loadData = require('packs/load_data');
var url, data_id, type, page;

$(document).ready(function() {
  $('#followers-list').on('click', function() {
    $('#load-more').show();
    data_id = $('.user-profile').attr('data_id');
    url = '/users/' + data_id + '/followers';
    page = 1;
    appendData();
  });

  $('#following-list').on('click', function() {
    $('#load-more').show();
    data_id = $('.user-profile').attr('data_id');
    url = '/users/' + data_id + '/following';
    page = 1;
    appendData();
  });

  $('body').on('click', '.like-list', function() {
    $('#load-more').show();
    data_id = $(this)
      .closest('.instagram-card')
      .attr('data_id');
    url = '/posts/' + data_id + '/likers';
    page = 1;
    appendData();
  });

  function appendData() {
    $('.people__list').empty();

    loadData(url, { page: page });

    $('#load-more').on('click', function() {
      page++;
      loadData(url, { page: page });
    });
  }
});
