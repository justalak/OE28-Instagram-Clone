var loadData = function(url, data) {
  $.ajax({
    type: 'GET',
    url: url,
    data: data,
    dataType: 'script'
  });
};
module.exports = loadData;
