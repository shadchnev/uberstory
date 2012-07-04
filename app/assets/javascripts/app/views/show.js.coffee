App.Views.Show = Backbone.View.extend
  
  events:
    'click #header #logo a': 'navigateHome'
  
  initialize: ->
    @story = @options.story
    @user = @options.user
    @render()
    
  navigateHome: ->
    window.location.hash = '#'
  
  render: ->    
    Handlebars.registerHelper 'currentUserImage', (=> @user.image)  
    Handlebars.registerHelper 'friendsToInvite', (=> @story.friendsToInviteBack(@user))
    $(@el).html Handlebars.templates['app/templates/story'](@story)
    $("#container").html @el
    
    
  
