App.Collections.TopStories = Backbone.Collection.extend
  model: Story
  url: "/stories/top"