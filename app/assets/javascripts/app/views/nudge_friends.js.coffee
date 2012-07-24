App.Views.NudgeFriends = Backbone.View.extend

  events:
    'click .nudge': 'nudge'
    
  initialize: -> 
    @setElement $('#story-nudge-dialogue')
    @render()
    
  nudge: ->
    $(@el).modal('hide')
    @remove()
    console.log("started pestering friends...")

  render: ->
    $(@el).modal('show')