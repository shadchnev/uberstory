App.Views.Show = Backbone.View.extend
  
  
  events:
    'click #header #logo a': 'navigateHome'
    'click #after-new-line-dialogue .invite-friends': 'addLine'
    'keyup .new-line input': 'checkButtonState'
    'click #new-line-dialogue': 'showNewLineModal'
  
  initialize: ->
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
    
  navigateHome: ->
    window.location.hash = '#'
  
  showNewLineModal: ->
    text = $(".add-new-line .new-line input").val().trim()
    return false if text is ''
    $('#after-new-line-dialogue').modal('show')
    
  checkButtonState: ->
    text = $(".add-new-line .new-line input").val().trim()
    if text is ''
      $("a#new-line-dialogue").addClass('disabled')      
    else
      $("a#new-line-dialogue").removeClass('disabled')
  
  addLine: ->
    text = $(".add-new-line .new-line input").val().trim()
    line = new Line({text: text, story_id: @story.get('id'), user: @user})
    @story.lines.add(line)        
    @showFacebookInvite()
    false
    
  showFacebookInvite: (callback, friendsToInvite) ->
    $(".modal").modal('hide')
    userIds = friendsToInvite || []
    FB.ui
      method: 'apprequests'
      message: 'Help me finish a short story on UberTales!'
      title: "Let's write a story together!"
      to: userIds
      callback
        
  render: ->    
    Handlebars.registerHelper 'currentUserImage', (=> @user.image)  
    Handlebars.registerHelper 'friendsToInvite', (=> @story.friendsToInviteBack(@user))
    $(@el).html Handlebars.templates['app/templates/story'](@story)
    $("#container").html @el
    @delegateEvents()
    
  
