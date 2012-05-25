# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

friendsInvited = false

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

initPopover = ->
  $(".blurred").popover()

bindNewStoryForm = ->
  $("form#new_story").submit ->
    friendsInvited  

bindNewStoryButton = ->
  $('.start-story').click ->
    callback = (response) ->
      if response?
        friendsInvited = true
        $("form#new_story").submit()
      else 
        $("#no-friends-dialogue").modal("show")
    showFacebookInvite(callback)

bindInviteFriendsButton = ->
  $(".invite-friends").click ->
    showFacebookInvite ->
      $(".alert").show() if response?
  
storyBanter = ->
  banter = new Array()
  banter[0] = "Wow, you really are talented!"
  banter[1] = "Beautiful. The start of a masterpiece"
  banter[2] = "Wow, that line will be quoted for centuries to come!"
  banter[3] = "Amazing! One day this story will be made into a movie."
  banter

bindHeaderForm = ->
  $("form#new_story .new-line input").keypress ->
    $("form#new_story .new-line").removeClass("error")
  
  $('a.start-new-story').click ->
    newLine = $("form#new_story input.new_line").val()
    if newLine == ''    
      $("form#new_story .new-line input").focus()
      $("form#new_story .new-line").addClass("error")
    else
      makeRandom = Math.floor(Math.random() * storyBanter().length)
      $(".new-story-banter").html(storyBanter()[makeRandom])
      $("#new-story-dialogue").modal("show")
      
$ -> # this is where it all starts
  initPopover()
  bindNewStoryForm()
  bindNewStoryButton()
  bindInviteFriendsButton()
  bindHeaderForm()
  
  
      
  