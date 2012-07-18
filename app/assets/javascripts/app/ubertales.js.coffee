window.App =
  Views: {}
  Routers: {}
  Collections: {}
  Models: {}
  init: ->
    new App.Routers.Stories()
    Backbone.history.start()

Handlebars.templates = {}; # for hamlbars to puts templates into  

$ ->
  if $('#signed-request').text().length
    $.ajaxSetup
      data:
        signed_request: $('#signed-request').text()  
  App.init()
