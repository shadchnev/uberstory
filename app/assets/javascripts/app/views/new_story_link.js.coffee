App.Views.NewStoryLink = Backbone.View.extend
  
  events:
    'click #start-new-story': 'showNewStoryView'
  
  initialize: -> 
    @user = @options.user
    
  showNewStoryView: ->
    @view = new App.Views.NewStory(user: @user)
    @view.on("storyCreated", (story)=> @trigger("storyCreated", story))

  render: ->
    $(@el).html(Handlebars.templates['app/templates/new_story_link']())