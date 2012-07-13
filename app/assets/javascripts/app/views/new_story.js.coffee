App.Views.NewStory = Backbone.View.extend

  events:
    'click .start-story': 'showFriendsSelector'

  initialize: -> 
    @setElement $('#new-story-dialogue')
    @render()
    
  showFriendsSelector: ->
    $(@el).modal('hide')
    new App.Views.SelectFriends()
    
  render: ->
    $(@el).modal('show')