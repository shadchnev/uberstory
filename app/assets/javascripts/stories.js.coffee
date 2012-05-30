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

startWritingStory = ->
  newLine = $("form#new_story input.new_line").val()
  if newLine == ''    
    $("form#new_story .new-line input").focus()
    $("form#new_story .new-line").addClass("error")
  else
    _kmq.push(['record', 'Entered a new line']);
    $(".new-story-banter").html(randomNewStoryBanter())
    $("#new-story-dialogue").modal("show")  

bindNewStoryForm = ->
  $("form#new_story").submit ->
    unless friendsInvited      
      startWritingStory()
      return false

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
  $(".invite-friends", ".invite-friends-line").click ->
    showFacebookInvite (response)->
      _kmq.push(['record', 'Invited Friends', {number: (if response then response.to.length else 0)}])
      $(".alert").show() if response?
  
randomNewStoryBanter = ->
  banter = new Array(
    "Wow, you really are talented!",
    "Beautiful. The start of a masterpiece",
    "Wow, that line will be quoted for centuries to come!",
    "Amazing! One day this story will be made into a movie.",
  )
  index = Math.floor(Math.random() * banter.length)
  banter[index]

bindHeaderForm = ->
  $("form#new_story .new-line input").keypress ->
    $("form#new_story .new-line").removeClass("error")
  
  $('a.start-new-story').click ->
    $("form#new_story").submit()
    
bindAddNewLine = ->
  $(".add-new-line a").click ->
    $(".add-new-line form").submit()
  $(".invite-friends", "#after-new-line-dialogue").click ->
    showFacebookInvite ->
      _kmq.push(['record', 'Invited Friends To Continue', {number: (if response then response.to.length else 0)}])
      friendsInvited = true
      $(".add-new-line form").submit()    
  $(".i-have-no-friends", "#after-new-line-dialogue").click ->
    $(".add-new-line form").submit()    
  $(".add-new-line form").submit ->
    return false if $("input[type='text']", this).val().replace(/\s/, '') == ''
    _kmq.push(['record', 'Added a new line']);
    unless friendsInvited
      $("#after-new-line-dialogue").modal('show')
      return false

bindCoverClick = ->
  $(".story-intro").click (event) ->
    document.location = $(this).attr("data-url");
    
$ ->
  initPopover()
  bindNewStoryForm()
  bindNewStoryButton()
  bindInviteFriendsButton()
  bindHeaderForm()
  bindAddNewLine()
  bindCoverClick()
  
  
      
  