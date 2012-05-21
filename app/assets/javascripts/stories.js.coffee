# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#invite-friends').click ->
    callback = (response) ->
     console.log response
    FB.ui
      method: 'apprequests'
      message: 'Help me finish a short story on Uberstory!'
      callback