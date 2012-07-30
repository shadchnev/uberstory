window.Line = Backbone.Model.extend

  url: ->
    base = 'lines'
    return base if @isNew()
    base + '/' + @id

  initialize: ->
    @user = new User(@attributes.user)
    @text = @get("text")
    @visible = @get('visible')

  authorImage: ->
    @user.image()

  authorName: ->
    @user.name()
    
  toJSON: ->
    json = JSON.parse(JSON.stringify(@attributes))    
    json.user = undefined
    _.extend(json, $.ajaxSettings.data)
    