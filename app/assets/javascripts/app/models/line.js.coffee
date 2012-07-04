window.Line = Backbone.Model.extend

  initialize: ->
    @user = new User(@attributes.user)