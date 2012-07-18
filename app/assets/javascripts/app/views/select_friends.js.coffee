App.Views.SelectFriends = Backbone.View.extend

  events:
    'click .add-friends:not(".disabled")' : "invokeCallback"
    'keyup #filter'      : "filterFriends"
    'click .checkbox input' : "toggleButtonState"

  initialize: ->
    @user = @options.user
    @setElement $("#select-friends").clone()
    @showBackButton = @options.showBackButton
    @callback = @options.callback
    @render()

  toggleButtonState: ->
    if $("input:checked", @el).length > 0
      $(".add-friends", @el).removeClass("disabled")      
    else
      $(".add-friends", @el).addClass("disabled")

  filterFriends: ->
    filter = $("#filter", @el).val().toLowerCase()
    return $(".friend", @el).show() unless filter
    friends = $(".friend", @el)
    matches = _.filter friends, (friend)->
      $(".checkbox input", friend).is(":checked") or $(".name", friend).text().toLowerCase().indexOf(filter) > -1
    $(".friend", @el).hide()
    $(match).show() for match in matches

  inviteFacebookFriends: (friends, callback)->    
    FB.ui
      method: 'apprequests'
      message: 'Help me finish a short story on UberTales!'
      title: "Let's write a story together!"
      to: friends
      callback
    
  invokeCallback: ->
    friends = _.map $(".friend .checkbox input:checked", @el).parents('.friend').find(".uid"), (e) -> $(e).text()
    @inviteFacebookFriends friends, @callback
    # @callback()
    $(@el).modal('hide')
    @remove()
    false
    
  render: ->    
    $('.go-back', @el).hide() unless @showBackButton
    html = Handlebars.templates['app/templates/friends_list'](friends: @user.friends.models)
    $('.friends-list', @el).empty().html html
    $(@el).modal('show')    
    @