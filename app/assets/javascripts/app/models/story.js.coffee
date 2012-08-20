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
    @initInvitees()
    @initLines()    
    @initUsers() 
    @setCoAuthors()

  invite: (invitees) ->
    @set(newInviteesUids: invitees)    
    
  initUser: ->
    @user = new User(@attributes.user)
    
  initLines: ->
    @lines = new App.Collections.Lines()
    @lines.reset(@attributes.lines)
  
  initUsers: ->
    @users = new App.Collections.Users()
    users = _.uniq _.pluck(@lines.models, 'user'), false, (u)-> u.get("uid")
    @users.reset(users)
  
  initInvitees: ->
    @invitees = new App.Collections.Users()    
    @invitees.reset(@get('invitees'))
    @invitees.push(@user) if @invitees.where({id: @user.id}).length == 0

  
  toJSON: ->
    # json = {story: _.clone(@attributes)}
    json = {story: {}}
    _.extend(json.story, {invitees: @.get("newInviteesUids"), lines_attributes: [{text: @lines.last().text}]})
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