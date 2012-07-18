App.Views.StoryStarted = Backbone.View.extend

  events:
    'click .share': 'showSharingDialogue'
    
  initialize: -> 
    @setElement $('#story-started-dialogue').clone()
    @render()
    
  showSharingDialogue: ->
    $(@el).modal('hide')
    @remove()
    console.log("showing facebook sharing dialogue")

  render: ->
    $(@el).modal('show')