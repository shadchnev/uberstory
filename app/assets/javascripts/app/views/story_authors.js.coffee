App.Views.StoryAuthors = Backbone.View.extend

  initialize: ->
    @story = @options.story
    
  render: ->
    $(@el).html(Handlebars.templates['app/templates/authors'](authors: @story.invitees.models))
    @