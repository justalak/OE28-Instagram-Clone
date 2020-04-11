var loadData = require('packs/load_data');
var url, data_id, type, page;

function appendData() {
  $('.people__list').empty();

  loadData(url, { page: page, type: type });

  $('#load-more').on('click', function() {
    page++;
    loadData(url, { page: page, type: type });
  });
}

$(document).ready(function() {
  $('#followers-list').on('click', function() {
    data_id = $('.user-profile').attr('data_id');
    $('#load-more' + data_id).show();
    url = '/users/' + data_id + '/followers';
    page = 1;
    appendData();
  });

  $('#following-list').on('click', function() {
    data_id = $('.user-profile').attr('data_id');
    $('#load-more' + data_id).show();
    url = '/users/' + data_id + '/following';
    page = 1;
    appendData();
  });

  $('body').on('click', '.like-list', function() {
    data_id = $(this).data('id');
    $('#load-more' + data_id).show();
    url = '/posts/' + data_id + '/likers';
    page = 1;
    type = 'Post'
    appendData();
  });

  $('body').on('click', '.like-comment-list', function() {
    data_id = $(this).data('id');
    $('#load-more' + data_id).show();
    url = '/posts/' + data_id + '/likers';
    page = 1;
    type = 'Comment';
    appendData();
  });

  $('body').on('click', '.followers-list-button', function() {
    data_id = $(this).data('id');
    $('#load-more' + data_id).show();
    url = '/users/' + data_id + '/followers';
    page = 1;
    appendData();
  });

  $('body').on('click', '.following-list-button', function() {
    data_id = $(this).data('id');
    $('#load-more' + data_id).show();
    url = '/users/' + data_id + '/following';
    page = 1;
    appendData();
  });

  $('body').on('click', '.likers-list-button', function() {
    data_id = $(this).data('id');
    $('#load-more' + data_id).show();
    url = '/posts/' + data_id + '/likers';
    page = 1;
    type = 'Post';
    appendData();
  });

  $('#searh_user_input_name').keyup(function(event) {
    $('#submit_search_user').click();
  }).keydown(function(event) {
    if ( event.which == 13 ) {
      event.preventDefault();
    }
  });
});
