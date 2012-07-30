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
      @story.save null,
        success: (reply)=>
          new App.Views.LineAdded(scores: reply, user: @user) 
          @trigger 'storyUpdated', @story

  showNewLineModal: ->
    text = $(".add-new-line .new-line input").val().trim()
    return false if text is ''
    new App.Views.SelectFriends(showBackButton: true, callback: ((response)=> @addLine(response)), user: @user, message: "Hey, I'm writing a funny story, help me finish it!", data: {story_id: @story.id}) 
    false
    
  checkButtonState: ->
    text = $(".add-new-line .new-line input").val().trim()
    if text is ''
      $("a#new-line-dialogue").addClass('disabled')      
    else
      $("a#new-line-dialogue").removeClass('disabled')
  
  addLine: (response)->
    text = $(".add-new-line .new-line input").val().trim()
    line = new Line({text: text, story_id: @story.get('id')})
    @story.invite(response.to) if response?.to?.length
    @story.lines.add(line)         
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
    
  
