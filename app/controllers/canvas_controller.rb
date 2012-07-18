class CanvasController < ApplicationController
  
  NUM_STORIES_TO_SHOW = 20 # number of stories to show in a section on the homepage
  
  def index
    stories_by_friends = current_user.friends.map{|f| f.stories}.flatten.uniq
    stories_by_friends_and_myself = stories_by_friends + current_user.stories
    @in_play_stories = Story.in_play(:current_user => current_user)
    @friends_stories = Story.friends(:current_user => current_user)
    @top_stories = Story.top(:current_user => current_user)
    @your_stories = Story.yours(:current_user => current_user)
  end
  
end
