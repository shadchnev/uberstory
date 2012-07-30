# Understands how to map our models to DOM
App.Views.Index = Backbone.View.extend

  events:
    'click .read-story, .your-turn': "show"
    'click .nudge': 'showNudgeDialogue'
    'click #list-nav a, #completed .nav-tabs a': 'storyListTabs'

  initialize: ->
    @inPlayStories = @options.inPlayStories
    @topStories = @options.topStories
    @yourStories = @options.yourStories
    @friendsStories = @options.friendsStories    
    
  show: (event)->    
    document.location.hash = "#stories/" + @id(event.target)
    false

  id: (element)->
    $('[name="story-id"]', $(element).parents(".story-intro")).val()

  showNudgeDialogue: ->
    new App.Views.NudgeFriends(id: @id(event.target))

  storyListTabs: (ev)->
    target = $(ev.target)
    link = target.parent().addClass("active").siblings().removeClass("active")
    pane = target.attr("href")
    $(pane).show().siblings().hide()
    $(".scrollPane").tinyscrollbar()
    false
    
  render: ->
    Handlebars.registerHelper "coAuthorsCount", ->
      numberOfAuthors = @users.length
      res = @users.at(0)?.name()
      if numberOfAuthors > 1
        res += " and #{numberOfAuthors - 1} others" 
      res      
    storiesHtml = Handlebars.templates['app/templates/stories'] {inPlayStories: @inPlayStories, topStories: @topStories, yourStories: @yourStories, friendsStories: @friendsStories}
    $(@el).html(storiesHtml)
    $(".scrollPane", @el).tinyscrollbar()
    # $(@el).html(@el)
    @delegateEvents()
    @
    
