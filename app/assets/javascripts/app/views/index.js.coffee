# Understands how to map our models to DOM
App.Views.Index = Backbone.View.extend

  events:
    'click .cover': "show"

  initialize: ->
    @storiesByFriends = @options.stories
    @render()
    
  show: (event)->
    id = $('[name="story-id"]', $(event.target).parents(".story-intro")).val()
    document.location.hash = "#stories/" + id
    
  render: ->
    storiesByFriendsHtml = @renderStoriesSection('Stories by your friends', 'section', @storiesByFriends)
    $(@el).html(storiesByFriendsHtml)
    $("#container").html(@el)
    @
    
  renderStoriesSection: (title, name, stories)->    
    Handlebars.registerHelper "coAuthorsCount", ->
      numberOfAuthors = @attributes.users.length - 1
      res = @attributes.users[0].name
      if numberOfAuthors > 1
        res += " and #{numberOfAuthors - 1} others" 
      res      
    rows = []
    addToRow = (story, index) ->
      i = Math.floor(index / 3)
      rows[i] ||= {stories: []}
      rows[i].stories.push story
    addToRow(story, index) for story, index in stories
    Handlebars.templates['app/templates/section'] {title: title, rows: rows}
    