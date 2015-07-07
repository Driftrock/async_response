var AsyncResponse = (function($){
  function Module() {}

  var loadAsyncJSON = function(url, onProgress, onLoad){
    $.getJSON(url, function(data) {
      if (!data.status) {
        loadAsyncJSON(url, onProgress, onLoad);
        return;
      }

      var status = data.status;
      if (status == 'finished') {
        onLoad(data.data);
        return;
      } else {

        onProgress(data.status, data.percentage_completion);
        loadAsyncJSON(url, onProgress, onLoad);
      }
    });
  }

  Module.prototype.loadJSON = function(options) {
    var url = options.url;
    var onLoad = options.onLoad || function() {};
    var onProgress = options.onProgress || function() {};

    loadAsyncJSON(url, onProgress, onLoad);
    return url;
  }

  return Module;

})(jQuery);
