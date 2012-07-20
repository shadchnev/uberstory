window.User = Backbone.Model.extend
  
  initialize: ->    
    @friends = new App.Collections.Users()
    @friends.reset @get("friends")
    @uid = @get 'uid'
    # @image = @get 'image'
    @firstName = @get 'first_name'
    @lastName = @get 'last_name'
    

  image: ->
    "https://graph.facebook.com/#{@uid}/picture"

  name: ->
    "#{@firstName} #{@lastName}"
    
