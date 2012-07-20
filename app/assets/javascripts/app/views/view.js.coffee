Backbone.View.prototype.close = ->  
  @remove()
  @unbind()
  @onClose() if @onClose