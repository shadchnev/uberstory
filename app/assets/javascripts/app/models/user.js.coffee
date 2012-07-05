window.User = Backbone.Model.extend
  
  initialize: ->
    @image = @get('image')
    @friends = new App.Collections.Users()
    @friends.reset @get("friends")
    
