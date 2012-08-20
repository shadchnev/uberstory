App.Routers.Stories = Backbone.Router.extend
  routes:
    "": "index"
    "stories/:id": "show"

  initialize: ->
    @contentView            = new App.Views.Window(element: "#content")
    @sidebarTopView         = new App.Views.Window(element: "#sidebar-top")
    @sidebarBottomView      = new App.Views.Window(element: "#sidebar-bottom")
    @homeLinkView           = new App.Views.Window(element: "#homelink")
    @scoreView              = new App.Views.Window(element: "#score-count")
    @loadSeed()

  show: (id)->
    story = @inPlayStories.get(id) or @topStories.get(id) or @yourStories.get(id) or @friendsStories.get(id)
    showStoryView = new App.Views.Show story: story, user: @user
    @contentView.render         showStoryView
    @sidebarTopView.render      new App.Views.ShareStory(story: story, user: @user)
    @sidebarBottomView.render   new App.Views.StoryAuthors(story: story)
    @homeLinkView.render        new App.Views.Homelink(story: story)        
    showStoryView.on "storyUpdated", (story) =>      
      # console.log("catching the storyUpdated event")
      @inPlayStories.fetch success: => 
        @index()

  loadSeed: ->
    @user ?= new User(JSON.parse $('#seed #current-user').text())
    @user.on "change:score", =>      
      @scoreView.render new App.Views.Score(user: @user)      
      @leaders.fetch success: =>
        @sidebarBottomView.render new App.Views.Leaderboard(leaders: @leaders)        

    @scoreView.render new App.Views.Score(user: @user)
    @leaders ?= new App.Collections.Leaders()
    @leaders.reset JSON.parse($('#seed #leaders').text())

    
    @inPlayStories ?= new App.Collections.InPlayStories()    
    @inPlayStories.reset(JSON.parse $('#seed #in_play_stories').text()) if $('#seed #in_play_stories').length
    
    @topStories ?= new App.Collections.TopStories()    
    @topStories.reset(JSON.parse $('#seed #top_stories').text()) if $('#seed #top_stories').length

    @yourStories ?= new App.Collections.YourStories()    
    @yourStories.reset(JSON.parse $('#seed #your_stories').text()) if $('#seed #your_stories').length

    @friendsStories ?= new App.Collections.FriendsStories()    
    @friendsStories.reset(JSON.parse $('#seed #friends_stories').text()) if $('#seed #friends_stories').length
        
  index: ->
    @indexView = new App.Views.Index inPlayStories: @inPlayStories, topStories: @topStories, yourStories: @yourStories, friendsStories: @friendsStories, user: @user
    @contentView.render @indexView

    @newStoryLinkView = new App.Views.NewStoryLink(user: @user)
    @sidebarTopView.render @newStoryLinkView

    @newStoryLinkView.on "storyCreated", (story)=>      
      @inPlayStories.fetch success: => 
        @indexView.inPlayStories = @inPlayStories
        @contentView.render @indexView

    @sidebarBottomView.render new App.Views.Leaderboard(leaders: @leaders)
    @homeLinkView.render new App.Views.Homelink()
      