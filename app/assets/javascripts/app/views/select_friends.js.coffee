App.Views.SelectFriends = Backbone.View.extend

  events:
    'click .add-friends' : "invokeCallback"

  initialize: ->
    @setElement $("#select-friends")
    @showBackButton = @options.showBackButton
    @callback = @options.callback
    @render()
    
  invokeCallback: ->
    @callback()
    $(@el).modal('hide')
    false
    
  render: ->    
    $('.go-back', @el).hide() unless @showBackButton
    $(@el).modal('show')
    @