App.Views.StoryAuthors = Backbone.View.extend

  initialize: ->
    @story = @options.story
    @setElement $('#sidebar-bottom')
    @render()
    
  render: ->
    $(@el).html(Handlebars.templates['app/templates/authors'](authors: @story.users.models))
    @