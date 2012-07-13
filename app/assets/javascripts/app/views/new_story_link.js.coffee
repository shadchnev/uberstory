App.Views.NewStoryLink = Backbone.View.extend
  
  events:
    'click #start-new-story': 'showNewStoryView'
  
  initialize: -> 
    @setElement $('#sidebar-top')
    @render()
    
  showNewStoryView: ->
    new App.Views.NewStory()

  render: ->
    $(@el).html(Handlebars.templates['app/templates/new_story_link']())