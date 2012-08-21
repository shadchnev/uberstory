App.Views.Show = Backbone.View.extend
  
  
  events:
    'keyup .new-line input': 'checkButtonState'
    'click #new-line-dialogue': 'showNewLineModal'
    'click .invite-friends': 'inviteMoreFriends'
    'click .invite-friends-back': 'inviteFriendsBack'
  
  initialize: ->
    # console.log('initializing Show')
    @story = @options.story
    @user = @options.user
    @initLineChangeHander()
    @story.on "change", (story) =>
      @initLineChangeHander()      
      @render()      
    
  initLineChangeHander: ->
    @story.lines.off()
    @story.lines.on "add", (line) =>
      @story.save null,
        success: (reply)=>
          # new App.Views.LineAdded(scores: reply, user: @user) 
          new App.Views.Modal(message: "You've scored 10 points for writing this line!", title: "Cool! This line will be quoted for centuries to come!")
          @trigger 'storyUpdated', @story
          @user.set("score", @user.get("score") + 10)

  showNewLineModal: ->
    text = $(".add-new-line .new-line input", @el).val().trim()
    return false if text is ''
    @addLine()
    false
    
  checkButtonState: ->
    text = $(".add-new-line .new-line input").val().trim()
    if text is ''
      $("a#new-line-dialogue").addClass('disabled')      
    else
      $("a#new-line-dialogue").removeClass('disabled')

  inviteMoreFriends: ->
    callback = (response)=>
      return unless response?.to?.length
      @story.invite(response.to) 
      new App.Views.Modal(message: "Great, your friends have got an invitation to join the story!", title: "Well done!")  
    @friendsSelector ||= new App.Views.SelectFriends(callback: callback, user: @user, message: "I'm writing a story, help me finish it!")
    @friendsSelector.render()
    false

  inviteFriendsBack: ->
    @inviteExistingPlayers =>
      new App.Views.Modal(message: "Great, we sent reminders to your friends!", title: "Well done!")  

  inviteExistingPlayers: (thankYouCallback)->    
    callback = (response)=>
      return unless response?.to?.length
      thankYouCallback() if thankYouCallback
    participants = _.intersection(@story.invitees.pluck("uid"), @user.friends.pluck("uid"))
    FB.ui
      method: 'apprequests'
      data: {story_id: @story.id}
      message: 'Hey, please help me to finish a story on UberTales!'
      title: "Only a few lines before our story is completed!"
      to: participants
      callback
    false
    
  addLine: (response)->    
    text = $(".add-new-line .new-line input").val().trim()
    line = new Line({text: text, story_id: @story.get('id')})
    @story.invite(response.to) if response?.to?.length
    @story.lines.add(line)                 
    @inviteExistingPlayers()
    false

  registerHelpers: ->
    Handlebars.registerHelper 'currentUserImage', (=> @user.image)  
    Handlebars.registerHelper 'friendsToInvite', (=> @story.friendsToInviteBack(@user))
    Handlebars.registerHelper 'first', ((context, block)=> block(context[0]))
    Handlebars.registerHelper 'showSeparator', (=> @story.lines.length > 4)
    Handlebars.registerHelper 'slice', (context, block) ->
      ret = ""
      limit = 3
      offset = Math.max(context.length - limit, 1)
      i = (if (offset < context.length) then offset else 1) # don't ever take the first line, it's always displayed
      j = (if ((limit + offset) < context.length) then (limit + offset) else context.length)
      ret += block(context[i++]) while i < j
      ret    
            
  render: ->    
    @registerHelpers()
    $(@el).html Handlebars.templates['app/templates/story'](@story)
    @
    
  
