App.Views.Show = Backbone.View.extend
  
  events:
    'click #header #logo a': 'navigateHome'
  
  initialize: ->
    @render()
    
  navigateHome: ->
    window.location.hash = '#'
  
  render: ->    
    Handlebars.registerHelper 'currentUserImage', ->
      "http://graph.facebook.com/222407569/picture?type=square"  
    Handlebars.registerHelper 'friendsToInviteBack', ->
      'all my friends'
    $(@el).html Handlebars.templates['app/templates/story'](@options.story)
    $("#container").html @el
  
