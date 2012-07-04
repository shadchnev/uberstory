class StoriesController < ApplicationController

  
  before_filter :authenticate_if_necessary
  
  def index
    # stories_by_friends_and_myself = current_user.friends_and_myself.map{|f| f.stories}.flatten.uniq
    # @by_friends = stories_by_friends_and_myself.sort_by{|s| s.writable_by(current_user) ? 0 : 1 }.take(NUM_STORIES_TO_SHOW)
    # @popular = (Story.all - stories_by_friends_and_myself).take(NUM_STORIES_TO_SHOW) # popular means the number of likes but we don't have that yet
    raise "old code moved to canvas controller, new code isn't written yet"
  end
  
  def new
    @story = Story.new
    @story.lines.build # not sure this is necessary
  end
  
  def show
    @story = Story.find(params[:id])
  end
  
  def create
    @story = Story.new(params[:story])
    @story.lines.first.user = current_user
    if @story.save
      flash[:notice] = "Boom, one shiny new story! Check back soon and watch the story grow."
      redirect_to :action => :show, :id => @story.id
    else
      render :new
    end
  end
  
  def update
    @story = Story.find(params[:id])
    @story.attributes = params[:story]
    @story.lines.last.user = current_user
    if @story.save
      fire 'line.added', :target_id => @story.lines.last.id
      @story.notify_all_users_except(current_user)
      redirect_to :action => :show
    else
      @story.reload
      render :show
    end
  end
  
  def invite  
    @story = Story.find(params[:id])
    @story.invite(params[:invitees])
    redirect_to :action => :index
  end
        
end
