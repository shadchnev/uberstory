App.Routers.Stories = Backbone.Router.extend
  routes:
    "": "index"
    "stories/:id": "show"
  
  show: (id)->
    story = @stories.get(id)    
    new App.Views.Show 
      story: story
      user: @user
    
  index: ->
    @user ?= new User(JSON.parse $('#current-user-seed').text())
    @stories ?= new App.Collections.Stories()    
    @stories.reset(JSON.parse $('#stories-by-friends-seed').text()) if @stories.isEmpty()
    new App.Views.Index stories: @stories.models      
    