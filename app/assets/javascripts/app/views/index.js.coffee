# Understands how to map our models to DOM
App.Views.Index = Backbone.View.extend

  events:
    'click .read-story, .your-turn': "show"
    'click .nudge': 'showNudgeDialogue'

  initialize: ->
    @inPlayStories = @options.inPlayStories
    @topStories = @options.topStories
    @yourStories = @options.yourStories
    @friendsStories = @options.friendsStories
    @render()
    
  show: (event)->    
    document.location.hash = "#stories/" + @id(event.target)
    false

  id: (element)->
    $('[name="story-id"]', $(element).parents(".story-intro")).val()

  showNudgeDialogue: ->
    new App.Views.NudgeFriends(id: @id(event.target))
    
  render: ->
    console.log("rendering index")
    Handlebars.registerHelper "coAuthorsCount", ->
      numberOfAuthors = @users.length - 1
      res = @users.at(0).get("name")
      if numberOfAuthors > 1
        res += " and #{numberOfAuthors - 1} others" 
      res      
    storiesHtml = Handlebars.templates['app/templates/stories'] {inPlayStories: @inPlayStories, topStories: @topStories, yourStories: @yourStories, friendsStories: @friendsStories}
    $(@el).html(storiesHtml)
    $("#content").html(@el)
    @delegateEvents()
    @
    
