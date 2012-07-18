App.Views.NewStory = Backbone.View.extend

  events:
    'click .start-story:not(".disabled")': 'showFriendsSelector'
    'keyup #first-line': 'toggleButtonState'

  initialize: -> 
    @user = @options.user
    @setElement $('#new-story-dialogue').clone()
    @render()

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
    console.log("first line: " + @firstLine)    
    $(@el).modal('hide')
    @remove()
    callback = (response) =>
      if response
        @createStory()
      else
        @flash = "Sorry, you need to invite your friends so that they could get a chance to write new lines! It's not fun otherwise :)"
        @render()
    new App.Views.SelectFriends(callback: callback, user: @user)

    
  createStory: ->
    story = new Story()
    console.log("first line again: " + @firstLine)
    line = new Line(text: @firstLine)
    story.lines.add(line)
    story.save null,
      success: => 
        console.log('story added')
        @trigger 'storyCreated', story    

  render: ->
    $(".flash", @el).html(@flash) if @flash?.length
    @flash = ''
    $(@el).modal('show')
    @delegateEvents()