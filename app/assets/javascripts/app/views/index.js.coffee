# Understands how to map our models to DOM
App.Views.Index = Backbone.View.extend

  events:
    'click .read-story, .your-turn': "show"

  initialize: ->
    @stories = @options.stories
    @render()
    
  show: (event)->
    id = $('[name="story-id"]', $(event.target).parents(".story-intro")).val()
    document.location.hash = "#stories/" + id
    false
    
  render: ->
    Handlebars.registerHelper "coAuthorsCount", ->
      numberOfAuthors = @users.length - 1
      res = @users.at(0).get("name")
      if numberOfAuthors > 1
        res += " and #{numberOfAuthors - 1} others" 
      res      
    storiesHtml = Handlebars.templates['app/templates/stories'] {stories: @stories}
    $(@el).html(storiesHtml)
    $("#content").html(@el)
    @
    
