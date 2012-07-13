App.Routers.Stories = Backbone.Router.extend
  routes:
    "": "index"
    "stories/:id": "show"
  
  show: (id)->
    story = @stories.get(id)    
    new App.Views.Show story: story, user: @user
    new App.Views.ShareStory(story: story)
    new App.Views.StoryAuthors(story: story)
    new App.Views.Homelink(story: story)
    
  index: ->
    @user ?= new User(JSON.parse $('#seed #current-user').text())
    @stories ?= new App.Collections.Stories()    
    @stories.reset(JSON.parse $('#seed #stories-by-friends').text()) if @stories.isEmpty()
    new App.Views.Index stories: @stories.models      
    new App.Views.NewStoryLink()
    new App.Views.Leaderboard()
    new App.Views.Homelink()
    