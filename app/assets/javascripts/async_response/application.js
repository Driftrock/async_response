//= require jquery_ujs

var Responses = (function($){

  var bindClicks = function(module) {
    $('.btn-show').on('click', function(){
      var id = $(this).data('id'),
          content = $(this).data('content');

      module.showResponse(id, content);
      return false;
    });
  }

  function Module(baseUrl) {
    this.baseUrl = baseUrl;

    bindClicks(this);
  }

  Module.prototype.showResponse = function(id, content) {
    $.getJSON(this.baseUrl+'/'+id+'.json', function(data){
      var showResponseHolder = $('#showResponseHolder'),
          display = content == 'data' ? data.data : data.error;

      showResponseHolder.html(JSON.stringify(display));

      $('.modal').modal({show: true});
    });
  };

  return Module;
})(jQuery);
