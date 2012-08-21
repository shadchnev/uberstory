App.Views.ShareStory = Backbone.View.extend

  events:
    'click .share': 'shareStory'

  initialize: ->
    @user = @options.user
    @story = @options.story

  shareStory: (event)-> 
    # console.log "sharing " + "http://uberstory.herokuapp.com/#stories/#{@story.id}"
    FB.ui
      method: 'send'
      name: "A story by #{@user.name()}"
      description: @story.teaser
      link: "http://uberstory.herokuapp.com/stories/#{@story.id}"
    false
    
  render: ->
    template = Handlebars.templates['app/templates/sharing'] 
    url = "http://uberstory.herokuapp.com/stories/#{@story.id}"
    html = if @story.finished then template({url: url}) else ''    
    $(@el).html(html)   
    FB?.XFBML.parse(@el) # this will work when the story is rendered after the page is loaded, otherwise see _facebook.haml
    @