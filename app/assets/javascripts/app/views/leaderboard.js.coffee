App.Views.Leaderboard = Backbone.View.extend
      
  initialize: ->
    @leaders = @options.leaders

  render: -> 
    $(@el).html(Handlebars.templates['app/templates/leaderboard'] {leaders: @leaders})