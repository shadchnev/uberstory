window.Line = Backbone.Model.extend

  initialize: ->
    @user = new User(@attributes.user)
    @text = @get("text")
    @visible = @get('visible')
    