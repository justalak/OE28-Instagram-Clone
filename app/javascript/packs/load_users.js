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
    type = 'Post'
    appendData();
  });

  $('.comment-wrapper').on('click', '.like-comment-list', function() {
    $('#load-more').show();
    data_id = $(this)
      .attr('data_id');
    url = '/posts/' + data_id + '/likers';
    page = 1;
    type = 'Comment';
    appendData();
  });

  function appendData() {
    $('.people__list').empty();

    loadData(url, { page: page, type: type });

    $('#load-more').on('click', function() {
      page++;
      loadData(url, { page: page, type: type });
    });
  }
});

$(document).ready(function() {
  var page = 1;
  var sort_val;
  var text_search = "";
  var type = "";
  $('#load-more-users-table').on('click', function() {
    url = '/admin/users';
    page++;
    text_search = $('#search_input').val();
    loadData(url, { page: page, type: type, sort_value: sort_val, text_search: text_search });
  });
  $('.sort_btn').on('click', function() {
    page = 1;
    sort_val = $(".sort_value").val();
    url = '/admin/users';
    type = "sort";
    loadData(url, { sort_value: sort_val, type: type, text_search: text_search });
  });
  $('#search_input').keyup(function(event) {
    url = '/admin/users';
    text_search = $(this).val();
    type = "search";
    loadData(url, { type: type, text_search: text_search });
  }).keydown(function(event) {
    if ( event.which == 13 ) {
      event.preventDefault();
    }
  });
});
