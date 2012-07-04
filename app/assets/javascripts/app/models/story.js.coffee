# Understands how to map our server-side models to views
window.Story = Backbone.Model.extend
  url: ->
    base = 'stories'
    return base if @isNew()
    base + '/' + @id
  
  initialize: ->   
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
    
  authorName: ->
    @user.get('name')
  
  authorImage: ->
    @user.get("image")
     
  setCoAuthors: ->
    coAuthors = @users.reject ((u) => u.id == @user.id)
    @coAuthors = _.first(coAuthors, 3)
  
  extraUsers: ->
    # return if story.users.count == 2
    # extra_friends = story.users - [current_user] - [current_user.friends]
    # return extra_friends.first.first_name if extra_friends.length == 1
    # return "#{extra_friends.count - mentioned_users_number} others"
          
  friendsToInviteBack: (currentUser)->    
    "invite the best friends of #{currentUser.id} back"
    # friendsToMention = @story.users
    # friends_to_mention = story.users & current_user.friends
    # friends_not_to_mention = story.users - [current_user] - friends_to_mention
    # names_to_mention = friends_to_mention.take(2)
    # names = names_to_mention.map{|u| u.first_name }.join(", ")
    # names = [names, extra_users(story, names_to_mention.size)].compact.join(" and ")
    # names

  