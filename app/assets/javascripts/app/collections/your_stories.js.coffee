App.Collections.YourStories = Backbone.Collection.extend
  model: Story
  url: "/stories/yours"