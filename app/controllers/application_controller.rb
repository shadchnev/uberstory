class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :sign_in_user
  before_filter :set_signed_request
  
  def set_signed_request
    @signed_request = params[:signed_request]
  end

  def url_options
    {:signed_request => params[:signed_request]}.merge(super)
  end
  
    
protected

  def fire(event, payload)
    payload[:user_id] = user_signed_in? && current_user.id
    # Delayed::Job.enqueue GamificationJob.new(event, payload)
    GamificationJob.new(event, payload).perform
  end

  def sign_in_user
    token, user_id = extract_token_and_user_id    
    @current_user = User.find_or_initialize_by_uid(user_id)
    # we need current_user in time for authentication to figure out the redirect url
    @current_user.token = token
    authenticate! and return unless token    
    if @current_user.no_data? # if we somehow delete the user from the db while they are authorised to access it, this will help
      @current_user.refresh_data 
    end
    @current_user.save!    
  end
  
  def current_user
    @current_user
  end
    
  def authenticate!    
    redirect = redirect_url
    story_id = params[:id] if params[:controller] == 'stories' && params[:action] == 'show'
    story = story_invited_to.tap{|v| puts "got story_invited_to: #{v.id if v}"}
    story_id = story.id if story
    query_string = "?story_id=#{story_id}" if story_id
    @redirect_url = "/auth/facebook#{query_string if query_string}"
    render "facebook/parent_redirect", :layout => false
  end

  def authenticate_if_necessary
    authenticate! unless user_signed_in?
  end
  
  def user_signed_in?
    !!current_user
  end

  def redirect_url
    story = story_invited_to
    story = Story.find(params[:story_id]) if !story && params[:story_id]
    story_url(story) if story
  end

private

  def graph
    return @graph if @graph
    @oauth = Koala::Facebook::OAuth.new(Rails.configuration.facebook_app_id, Rails.configuration.facebook_app_secret)    
    @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
  end


  def story_invited_to
    return if params[:request_ids].blank?
    request_ids = params[:request_ids].split(',')
    request = graph.get_object(request_ids.first)
    story_id = request ? !request["data"].nil? && JSON.parse(request["data"])["story_id"] : nil
    story_id ? Story.find(story_id) : nil #Story.all(:joins => :lines, :conditions => ['user_id in (?)', current_user.friend_of.map(&:id)]).last
  end

  def extract_token_and_user_id
    return unless params[:signed_request]
    @oauth = Koala::Facebook::OAuth.new(Rails.configuration.facebook_app_id, Rails.configuration.facebook_app_secret)
    @signed_request = @oauth.parse_signed_request(params[:signed_request]) 
    puts @signed_request.inspect
    [@signed_request["oauth_token"], @signed_request["user_id"]].tap{|v| puts "extracted from signed_request: #{v.inspect}"}
  end  

end
