# Understands how to map our server-side models to views
window.Story = Backbone.Model.extend
  url: ->
    base = 'stories'
    return base if @isNew()
    base + '/' + @id
  
  canAddNewLine: ->
    @attributes.writable_by_current_user
  
  initialize: ->    
    @coAuthors = _.reject @attributes.users, (u) =>
      u.id == @attributes.user.id
    @coAuthors = _.first(@coAuthors, 3)
  