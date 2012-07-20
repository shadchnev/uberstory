App.Views.Show = Backbone.View.extend
  
  
  events:
    'keyup .new-line input': 'checkButtonState'
    'click #new-line-dialogue': 'showNewLineModal'
  
  initialize: ->
    @story = @options.story
    @user = @options.user
    @initLineChangeHander()
    @story.on "change", (story) =>
      @initLineChangeHander()      
      @render()      
    
  initLineChangeHander: ->
    @story.lines.off()
    @story.lines.on "add", (line) =>
      line.save null, 
        success: (reply)=>
          new App.Views.LineAdded(scores: reply, user: @user) 
          @story.fetch()
    
  showNewLineModal: ->
    text = $(".add-new-line .new-line input").val().trim()
    return false if text is ''
    new App.Views.SelectFriends(showBackButton: true, callback: (=> @addLine()), user: @user)
    false
    
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
    false

  registerHelpers: ->
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
            
  render: ->    
    @registerHelpers()
    $(@el).html Handlebars.templates['app/templates/story'](@story)
    @
    
  
