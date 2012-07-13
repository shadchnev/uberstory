App.Views.ShareStory = Backbone.View.extend

  initialize: ->
    @setElement $('#sidebar-top')
    @story = @options.story
    @render()
    
  render: ->
    template = Handlebars.templates['app/templates/sharing']
    html = if @story.finished then template() else ''
    $(@el).html(html)
    @