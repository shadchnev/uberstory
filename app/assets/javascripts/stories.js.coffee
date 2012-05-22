# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  friendsInvited = false
  $("form#new_story").submit ->
    friendsInvited
  
  $("form#new_story .new-line input").keypress ->
    $("form#new_story .new-line").removeClass("error")
  
  $('a.show-modal').click ->
    newLine = $("form#new_story input.new_line").val()
    if newLine == ''    
      $("form#new_story .new-line input").focus()
      $("form#new_story .new-line").addClass("error")
    else
      $("#new-story-dialogue").modal("show")
  
  showFacebookInvite = (callback) ->
    $(".modal").modal('hide')
    checkboxes = $('.modal input[type="checkbox"]:checked')    
    userIds = $.map checkboxes, (element, index) ->
      $(element).val()
    userIds = userIds.join(",")
    FB.ui
      method: 'apprequests'
      message: 'Help me finish a short story on Uberstory!'
      to: userIds
      callback
  
  $(".invite-friends").click ->
    $("#continue-story-dialogue").modal("show")
  
  $(".continue-story").click ->
    showFacebookInvite ->
      $(".alert").show()
  
  $('.start-story').click ->
    callback = (response) ->
      if response?
        friendsInvited = true
        $("form#new_story").submit()
    showFacebookInvite(callback)
      