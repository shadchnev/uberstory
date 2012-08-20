App.Views.Score = Backbone.View.extend
  
  initialize: ->
    @user = @options.user

  render: ->
    $(@el).html(@user.get("score"))