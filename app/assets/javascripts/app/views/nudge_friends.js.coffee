App.Views.NudgeFriends = Backbone.View.extend

  events:
    'click .nudge': 'nudge'
    
  initialize: -> 
    @setElement $('#story-nudge-dialogue').clone()
    @story = @options.story
    @user = @options.user
    
  nudge: ->
    $(@el).modal('hide')
    FB.ui
      method: 'apprequests'
      data: {story_id: @story.id}
      message: 'Hey, please help me to finish a story on UberTales!'
      title: "Only a few lines before our story is completed!"
      to: _.intersection(@story.invitees.pluck("uid"), @user.friends.pluck("uid"))
      


  render: ->
    $(@el).modal('show')