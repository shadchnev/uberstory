$(function() {
  if ($('#user-uid').length) {
    _kmq.push(['identify', $('#user-uid')]);
    _kmq.push(['alias', $("#user-name"), $("#user-uid")]);      
  }
});