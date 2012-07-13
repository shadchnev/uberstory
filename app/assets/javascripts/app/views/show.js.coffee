App.Views.Show = Backbone.View.extend
  
  
  events:
    # 'click #after-new-line-dialogue .invite-friends': 'addLine'
    'keyup .new-line input': 'checkButtonState'
    'click #new-line-dialogue': 'showNewLineModal'
  
  initialize: ->
    @setElement $('#content')
    @story = @options.story
    @user = @options.user
    @render()
    @initLineChangeHander()
    @story.on "change", (story) =>
      @initLineChangeHander()
      @render()
    
  initLineChangeHander: ->
    @story.lines.off()
    @story.lines.on "add", (line) =>
      line.save null, 
        success: => 
          @story.fetch()
    
  showNewLineModal: ->
    text = $(".add-new-line .new-line input").val().trim()
    return false if text is ''
    new App.Views.SelectFriends(hideBackButton: true, callback: => @addLine())
    
  checkButtonState: ->
    text = $(".add-new-line .new-line input").val().trim()
    if text is ''
      $("a#new-line-dialogue").addClass('disabled')      
    else
      $("a#new-line-dialogue").removeClass('disabled')
  
  addLine: ->
    text = $(".add-new-line .new-line input").val().trim()
    line = new Line({text: text, story_id: @story.get('id')})
    @story.lines.add(line)
    # @showFacebookInvite()
    false
  #   
  # showFacebookInvite: (callback, friendsToInvite) ->
  #   $(".modal").modal('hide')
  #   userIds = friendsToInvite || []
  #   FB.ui
  #     method: 'apprequests'
  #     message: 'Help me finish a short story on UberTales!'
  #     title: "Let's write a story together!"
  #     to: userIds
  #     callback
  #       
  render: ->    
    Handlebars.registerHelper 'currentUserImage', (=> @user.image)  
    Handlebars.registerHelper 'friendsToInvite', (=> @story.friendsToInviteBack(@user))
    Handlebars.registerHelper 'first', ((context, block)=> block(context[0]))
    Handlebars.registerHelper 'showSeparator', (=> @story.lines.length > 4)
    Handlebars.registerHelper 'slice', (context, block) ->
      ret = ""
      offset = Math.max(context.length - 3, 1)
      limit = 3
      i = (if (offset < context.length) then offset else 0)
      j = (if ((limit + offset) < context.length) then (limit + offset) else context.length)
      ret += block(context[i++]) while i < j
      ret
    $(@el).html Handlebars.templates['app/templates/story'](@story)
    @delegateEvents()
    @
    
  
