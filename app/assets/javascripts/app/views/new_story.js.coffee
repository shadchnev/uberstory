App.Views.NewStory = Backbone.View.extend

  events:
    'click .start-story:not(".disabled")': 'showFriendsSelector'
    'keyup #first-line': 'toggleButtonState'

  initialize: -> 
    @user = @options.user
    @setElement $('#new-story-dialogue').clone()

  toggleButtonState: -> 
    if !!@getFirstLine()
      $(".start-story", @el).removeClass('disabled')
    else
      $(".start-story", @el).addClass('disabled')
    
  getFirstLine: ->
    $('#first-line', @el).val()?.trim()

  showFriendsSelector: (event)->
    # return if $(event.target).hasClass('disabled')
    @firstLine = @getFirstLine()
    # console.log("first line: " + @firstLine)    
    $(@el).modal('hide')
    @remove()
    callback = (response) =>
      if response?.to        
        @createStory(response.to)        
      else
        @flash = "Sorry, you need to invite your friends so that they could get a chance to write new lines! It's not fun otherwise :)"
        @render()
    @friendsSelector ||= new App.Views.SelectFriends(callback: callback, user: @user, message: "I started writing a new story, help me finish it!")
    @friendsSelector.render()

    
  createStory: (invitees)->
    story = new Story()
    story.invite(invitees)
    line = new Line(text: @firstLine)
    story.lines.add(line)
    story.save null,
      success: =>         
        @user.set("score", @user.get("score") + 25)
        @trigger 'storyCreated', story    

  render: ->
    $(".flash", @el).html(@flash)# if @flash?.length
    @flash = ''
    $(@el).modal('show')
    @delegateEvents()