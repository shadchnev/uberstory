App.Views.Homelink = Backbone.View.extend

  initialize: ->
    @story = @options.story
    
  render: ->
    homelink = Handlebars.templates['app/templates/homelink']()
    # html = if @story?.finished then homelink else ''
    html = if @story then homelink else ''
    $(@el).html html