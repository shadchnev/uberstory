App.Collections.InPlayStories = Backbone.Collection.extend
  model: Story
  url: "/stories/in_play"

  
  toJSON: (options)->
  	json = Backbone.Collection.prototype.toJSON.call(this, options)
  	_.extend(json, $.ajaxSettings.data)