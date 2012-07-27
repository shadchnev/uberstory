App.Views.SelectFriends = Backbone.View.extend

  events:
    'click .add-friends' : "invokeCallback"
    'keyup #filter'      : "filterFriends"
    'click .checkbox input' : "handleFriendSelect"
    'click .go-back': "cancelRequest" 

  initialize: ->
    @user = @options.user
    @data = @options.data
    @message = @options.message
    @setElement $("#select-friends")
    @showBackButton = @options.showBackButton
    @callback = @options.callback
    @render()

  toggleButtonState: ->
    if $("input:checked", @el).length > 0
      $(".add-friends", @el).removeClass("disabled")      
    else
      $(".add-friends", @el).addClass("disabled")

  setSelectedState: (ev)->
    target = $(ev.target)
    parent = target.parents(".friend")
    if target.is(":checked")
      parent.addClass("selected")
    else
      parent.removeClass("selected")

  handleFriendSelect: (ev)->
    @toggleButtonState()
    @setSelectedState(ev)

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
      data: @data
      message: @message or 'Help me finish a short story on UberTales!'
      title: "Let's write a story together!"
      to: friends
      callback

  cancelRequest: ->
    @callback()
    $(@el).modal('hide')
    false  
    
  invokeCallback: (event)->
    return false if $(event.target).hasClass("disabled")
    friends = _.map $(".friend .checkbox input:checked", @el).parents('.friend').find(".uid"), (e) -> $(e).text()
    @inviteFacebookFriends friends, @callback    
    $(@el).modal('hide')
    @remove()
    false
    
  render: ->    
    $('.go-back', @el).hide() unless @showBackButton
    html = Handlebars.templates['app/templates/friends_list'](friends: @user.friends.models)
    $('.friends-list', @el).empty().html html
    $(@el).modal('show')    
    @