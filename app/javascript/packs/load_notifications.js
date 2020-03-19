var loadData = require('packs/load_data');

$(document).ready(function() {
  var page = 1;
  var url = '/notifications';

  $('#load-notifications').unbind("click").on('click', function(){
      page++;
      loadData(url, {page: page});
  })
});
