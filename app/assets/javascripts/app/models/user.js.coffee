window.User = Backbone.Model.extend
  
  initialize: ->
    @image = @get('image')
    @friends = new App.Collections.Users()
    @friends.reset @get("friends")
    @uid = @get 'uid'
    @image = @get 'image'
    @name = @get 'name'    
    
