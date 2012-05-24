class StoriesController < ApplicationController
  
  def index
    authenticate! and return unless user_signed_in?
    @by_friends = current_user.friends.map{|f| f.stories}.flatten.uniq.sort_by{|s| s.created_at}.reverse.take(6)
    @popular = (Story.all - @by_friends).take(6) # popular means the number of likes but we don't have that yet
  end
  
  def new
    @story = Story.new
    @story.lines.build # not sure this is necessary
  end
  
  def show
    @story = Story.find(params[:id])
  end
  
  def create
    authenticate! and return unless user_signed_in?
    @story = Story.new(params[:story])
    @story.lines.first.user = current_user
    if @story.save
      flash[:notice] = "Story created successfully"
      redirect_to :action => :show, :id => @story.id
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
      redirect_to :action => :show
    else
      render :show
    end
  end
  
  def invite  
    @story = Story.find(params[:id])
    @story.invite(params[:invitees])
    redirect_to :action => :index
  end
    
end
