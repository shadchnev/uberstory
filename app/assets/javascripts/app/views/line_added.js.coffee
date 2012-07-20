App.Views.LineAdded = Backbone.View.extend

  events:
    'click .go-home': 'goHome'

  initialize: ->
    @scores = @options.scores
    @user = @options.user
    @setElement $("#line-added-dialogue").clone()
    @render()

  goHome: ->
    $(@el).modal('hide')
    @remove()
    document.location.hash = '#'
    false

  render: ->    
    $(@el).modal('show')