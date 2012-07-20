App.Routers.Stories = Backbone.Router.extend
  routes:
    "": "index"
    "stories/:id": "show"

  initialize: ->
    @contentView            = new App.Views.Window(element: "#content")
    @sidebarTopView         = new App.Views.Window(element: "#sidebar-top")
    @sidebarBottomView      = new App.Views.Window(element: "#sidebar-bottom")
    @homeLinkView           = new App.Views.Window(element: "#homelink")
    @loadSeed()

  show: (id)->
    story = @inPlayStories.get(id) or @topStories.get(id) or @yourStories.get(id) or @friendsStories.get(id)

    @contentView.render         new App.Views.Show story: story, user: @user
    @sidebarTopView.render      new App.Views.ShareStory(story: story, user: @user)
    @sidebarBottomView.render   new App.Views.StoryAuthors(story: story)
    @homeLinkView.render        new App.Views.Homelink(story: story)

  loadSeed: ->
    @user ?= new User(JSON.parse $('#seed #current-user').text())
    
    @inPlayStories ?= new App.Collections.InPlayStories()    
    @inPlayStories.reset(JSON.parse $('#seed #in_play_stories').text()) if $('#seed #in_play_stories').length
    
    @topStories ?= new App.Collections.TopStories()    
    @topStories.reset(JSON.parse $('#seed #top_stories').text()) if $('#seed #top_stories').length

    @yourStories ?= new App.Collections.YourStories()    
    @yourStories.reset(JSON.parse $('#seed #your_stories').text()) if $('#seed #your_stories').length

    @friendsStories ?= new App.Collections.FriendsStories()    
    @friendsStories.reset(JSON.parse $('#seed #friends_stories').text()) if $('#seed #friends_stories').length
        
  index: ->
    @contentView.render new App.Views.Index inPlayStories: @inPlayStories.models, topStories: @topStories.models, yourStories: @yourStories.models, friendsStories: @friendsStories.models

    @newStoryLinkView = new App.Views.NewStoryLink(user: @user)
    @sidebarTopView.render @newStoryLinkView

    @newStoryLinkView.on "storyCreated", (story)=>
      @storyStartedView = new App.Views.StoryStarted()
      @inPlayStories.fetch success: => 
        @indexView.inPlayStories = @inPlayStories.models # fuck me, that's some ugly code. As if a setter would solve my problems, though
        @indexView.render()

    @sidebarBottomView.render new App.Views.Leaderboard()
    @homeLinkView.render new App.Views.Homelink()
      