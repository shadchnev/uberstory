class LinesController < ApplicationController
  
  def create
    line = Line.new
    story = Story.find(params[:story_id])
    line.text = params[:text]
    line.user = current_user
    story.lines << line
    story.save!
    render :json => {:status => "OK"}
  end
  
end
