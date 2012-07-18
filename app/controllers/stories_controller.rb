class StoriesController < ApplicationController

  
  before_filter :authenticate_if_necessary
  
  def new
    @story = Story.new
    @story.lines.build # not sure this is necessary
  end
  
  def show
    @story = Story.find(params[:id])
    render :json => @story.as_json(:current_user => current_user)
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

  def in_play
    render :json => Story.in_play(:current_user => current_user).as_json(:current_user => current_user).to_json
  end

  def top
    render :json => Story.top(:limit => 20).as_json(:current_user => current_user).to_json
  end

  def yours
    render :json => Story.yours(:current_user => current_user).as_json(:current_user => current_user).to_json
  end

  def friends
    render :json => Story.friends(:current_user => current_user).as_json(:current_user => current_user).to_json
  end
        
end
