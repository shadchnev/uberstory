# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  friendsInvited = false
  $("form#new_story").submit ->
    friendsInvited
  
  $('a.show-modal').click ->
    newLine = $("form#new_story input.new_line").val()
    if newLine == ''    
      $("form#new_story .new-line").addClass("error")
    else
      $("#new-story-dialogue").modal("show")
  
  $('.start-story').click ->
    $("#new-story-dialogue").modal('hide')
    callback = (response) ->
      if response?
        friendsInvited = true
        $("form#new_story").submit()
    checkboxes = $('#new-story-dialogue input[type="checkbox"]:checked')    
    userIds = $.map checkboxes, (element, index) ->
      $(element).val()
    userIds = userIds.join(",")
    FB.ui
      method: 'apprequests'
      message: 'Help me finish a short story on Uberstory!'
      to: userIds
      callback
  