class CanvasController < ApplicationController
  
  NUM_STORIES_TO_SHOW = 20 # number of stories to show in a section on the homepage
  
  def index
    @in_play_stories = current_user.in_play_stories
    @friends_stories = current_user.friends_stories
    @top_stories = current_user.top_stories
    @your_stories = current_user.own_stories
  end
  
end
