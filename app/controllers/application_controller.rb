class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :sign_in_user

  def url_options
    {:signed_request => params[:signed_request]}.merge(super)
  end
  
protected

  def sign_in_user
    token, user_id = extract_token_and_user_id
    @current_user = User.find_or_initialize_by_uid(user_id)
    # we need current_user in time for authentication to figure out the redirect url
    authenticate! and return unless token    
    @current_user.token = token
    if @current_user.no_data? # if we somehow delete the user from the db while they are authorised to access it, this will help
      @current_user.refresh_data 
      @current_user.save!
    end
    
  end
  
  def current_user
    @current_user
  end
    
  def authenticate!    
    # KM.identify(current_user.uid); # isn't always available!
    # KM.record('Starting authentication');
    redirect = redirect_url
    @redirect_url = "/auth/facebook#{('?origin=' + redirect) if redirect}"
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
    story_url(story) if story
  end

private

  def story_invited_to
    return if params[:request_ids].blank? 
    request = current_user.graph.get_connections("me", "apprequests").reject{|r| r["data"].nil? }.sort_by{|r| Time.parse(r["created_time"])}.last
    story_id = JSON.parse(request["data"])["story_id"]
    story_id ? Story.find(story_id) : Story.all(:joins => :lines, :conditions => ['user_id in (?)', current_user.friend_of.map(&:id)]).last
  end

  def extract_token_and_user_id
    return unless params[:signed_request]
    @oauth = Koala::Facebook::OAuth.new(Rails.configuration.facebook_app_id, Rails.configuration.facebook_app_secret)
    @signed_request = @oauth.parse_signed_request(params[:signed_request]) 
    [@signed_request["oauth_token"], @signed_request["user_id"]]
  end  

end
