class CanvasController < ApplicationController
  
  NUM_STORIES_TO_SHOW = 6 # number of stories to show in a section on the homepage
  
  def index
    stories_by_friends_and_myself = current_user.friends_and_myself.map{|f| f.stories}.flatten.uniq
    @by_friends = stories_by_friends_and_myself.sort_by{|s| s.writable_by(current_user) ? 0 : 1 }.take(NUM_STORIES_TO_SHOW)
    @popular = (Story.all - stories_by_friends_and_myself).take(NUM_STORIES_TO_SHOW) # popular means the number of likes but we don't have that yet    
  end
  
end
