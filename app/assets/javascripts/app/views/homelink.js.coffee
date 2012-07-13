App.Views.Homelink = Backbone.View.extend

  initialize: ->
    @setElement $('#homelink')
    @story = @options.story
    @render()
    
  render: ->
    homelink = Handlebars.templates['app/templates/homelink']()
    html = if @story?.finished then homelink else ''
    return $(@el).html(html)