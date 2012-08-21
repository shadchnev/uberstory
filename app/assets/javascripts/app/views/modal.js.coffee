App.Views.Modal = Backbone.View.extend

  # events:
  #   'click .go-home': 'goHome'

  initialize: ->
    # @scores = @options.scores
    # @user = @options.user
    @title = @options.title
    @message = @options.message    
    @setElement $("#modal-dialogue")
    @render()

  # goHome: ->
  #   $(@el).modal('hide')
  #   @remove()
  #   document.location.hash = '#'
  #   false

  render: ->    
    $('.title', @el).html @title
    $('.modal-body', @el).html @message
    $(@el).modal('show')