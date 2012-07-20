App.Views.Window = Backbone.View.extend

  initialize: ->
    @setElement(@options.element)

  render: (view)->
    @view.close() if @view
    @view = view
    @view.render()
    $(@el).html(@view.el)