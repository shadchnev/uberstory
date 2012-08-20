window.Leader = Backbone.Model.extend

  # url: ->
  #   'users/leaders'    

  initialize: ->
    @score = @get 'score'
    @name = @get 'name'

