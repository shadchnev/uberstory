# Understands how to map our server-side models to views
window.Story = Backbone.Model.extend
  url: ->
    base = 'stories'
    return base if @isNew()
    base + '/' + @id
  
  initialize: ->   
    @on 'change', (=> @updateModels())
    @updateModels()
    @finished = @get('finished')
    @teaser = @get('teaser')
  
  updateModels: ->
    @initUser() 
    @initLines()    
    @initUsers() 
    @setCoAuthors()
    
  initUser: ->
    @user = new User(@attributes.user)
    
  initLines: ->
    @lines = new App.Collections.Lines()
    @lines.reset(@attributes.lines)
  
  initUsers: ->
    @users = new App.Collections.Users()
    users = _.pluck @lines.models, 'user'
    @users.reset(users)
  
  toJSON: ->
    json = {story: _.clone(@attributes)}
    _.extend(json.story, {lines_attributes: _.map(@lines.toJSON(), (l)-> delete l.signed_request; l)})    
    _.extend(json, $.ajaxSettings.data)
    
    
  authorName: ->
    @user.get('name')
  
  authorImage: ->
    @user.image()
     
  setCoAuthors: ->
    coAuthors = @users.reject ((u) => u.id == @user.id)
    @coAuthors = _.first(coAuthors, 3)
  
  friendsToInviteBack: (currentUser) ->
    extraUsers = (mentionedUsersNumber) =>
      return if @users.length == 2
      extraFriends = _.difference(@users.filter((u) -> u.id isnt currentUser.id), currentUser.friends)
      return extraFriends[0].get('first_name') if extraFriends.length == 1
      namesNumber = extraFriends.length - mentionedUsersNumber
      s = if namesNumber is 1 then '' else 's'
      "#{namesNumber} other#{s}"
      
    friendsToMention = @users.select ((e)=> currentUser.friends.any((u) -> e.id == u.id) )
    namesToMention = _.first friendsToMention, 2
    names = _.map namesToMention, ((u) -> u.get('first_name'))
    names = names.join(", ")
    names = _.compact([names, extraUsers(namesToMention.length)]).join(' and ')
    "Invite #{names} back"