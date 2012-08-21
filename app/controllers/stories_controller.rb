class StoriesController < ApplicationController

  
  before_filter :authenticate_if_necessary
  
  def new
    @story = Story.new
    @story.lines.build # not sure this is necessary
  end
  
  def show
    @story = Story.find(params[:id])
    respond_to do |format|
      format.html do
        @page_title = @story.teaser
        @redirect_url = canvas_url(:anchor => "stories/#{@story.id}")        
        render :show, :layout => false
      end
      format.json  do
        render :json => @story.as_json(:current_user => current_user)
      end
    end
  end
  
  def create
    params[:story][:invitees].map!{|uid| User.find_by_uid uid} if params[:story][:invitees] && !params[:story][:invitees].empty?
    @story = Story.new(params[:story])    
    @story.lines.first.user = current_user
    if @story.save
      # flash[:notice] = "Boom, one shiny new story! Check back soon and watch the story grow."
      # redirect_to :action => :show, :id => @story.id
      fire 'story.added', :target_id => @story.id
      render :json => {}, :status => :ok
    else
      render :json => {}, :status => :bad_request
    end
  end
  
  def update
    new_invitees = params[:story][:invitees].map{|uid| User.find_by_uid uid} if params[:story][:invitees] 
    new_line = Line.new(params[:story][:lines_attributes].first)
    new_line.user = current_user 
    @story = Story.find(params[:id])
    @story.lines << new_line
    @story.invitees << new_invitees if new_invitees    
    if @story.save
      fire 'line.added', :target_id => @story.lines.last.id
      @story.notify_all_users_except(current_user)
      render :json => {}, :status => :ok
    else      
      render :json => {}, :status => :bad_request
    end
  end
  
  def invite  
    @story = Story.find(params[:id])
    @story.invite(params[:invitees])
    redirect_to :action => :index
  end

  def in_play
    render :json => current_user.in_play_stories.as_json(:current_user => current_user).to_json
  end

  def top
    render :json => current_user.top_stories.as_json(:current_user => current_user).to_json
  end

  def yours
    render :json => current_user.finished_own_stories.as_json(:current_user => current_user).to_json
  end

  def friends
    render :json => current_user.finished_friends_stories.as_json(:current_user => current_user).to_json
  end
        
end