class StoriesController < ApplicationController
  
  def index
    authenticate! and return unless user_signed_in?
    @stories = Story.all
  end
  
  def new
    @story = Story.new
    @story.lines.build # not sure this is necessary
  end
  
  def continue
    @story = Story.find(params[:id])
  end
  
  def create
    authenticate! and return unless user_signed_in?
    @story = Story.new(params[:story])
    @story.lines.first.user = current_user
    if @story.save
      redirect_to :action => :index
    else
      render :new
    end
  end
  
  def update
    authenticate! and return unless user_signed_in?
    @story = Story.find(params[:id])
    @story.update_attributes(params[:story])
    @story.lines.last.user = current_user
    if @story.save
      redirect_to :action => :index
    else
      render :continue
    end
  end
  
  def invite  
    @story = Story.find(params[:id])
    @story.invite(params[:invitees])
    redirect_to :action => :index
  end
    
end