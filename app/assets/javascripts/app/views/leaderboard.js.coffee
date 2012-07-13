App.Views.Leaderboard = Backbone.View.extend

  initialize: ->
    @render()
    
  render: -> 
    $('#sidebar-bottom').html("Leaderboard")