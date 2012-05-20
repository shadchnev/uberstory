class StoriesController < ApplicationController
  
  def index
    authenticate! and return unless user_signed_in?
    @stories = Story.all
  end
  
  def new
    @story = Story.new
    @story.lines.build
  end
  
  def create
    @story = Story.new(params[:story])
    user = User.find_by_token(token)
    authenticate! and return unless user
    @story.lines.first.user = user
    if @story.save
      redirect_to :action => :index
    else
      render :new
    end
  end
    
end
