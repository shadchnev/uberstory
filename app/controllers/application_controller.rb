class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :sign_in_user

  def url_options
    {:signed_request => params[:signed_request]}.merge(super)
  end
  
protected

  def sign_in_user
    token, user_id = extract_token_and_user_id
    authenticate! and return unless token    
    @current_user = User.find_or_initialize_by_uid(user_id)
    @current_user.token = token
    if @current_user.no_data? # if we somehow delete the user from the db while they are authorised to access it, this will help
      @current_user.refresh_data 
      @current_user.save
    end
    
  end
  
  def current_user
    @current_user
  end
    
  def authenticate!    
    @redirect_url = "/auth/facebook?origin=#{redirect_url}"
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
    Story.all(:joins => :lines, :conditions => ['user_id in (?)', current_user.friend_of.map(&:id)]).last
  end

  def extract_token_and_user_id
    return unless params[:signed_request]
    @oauth = Koala::Facebook::OAuth.new(Rails.configuration.facebook_app_id, Rails.configuration.facebook_app_secret)
    @signed_request = @oauth.parse_signed_request(params[:signed_request]) 
    [@signed_request["oauth_token"], @signed_request["user_id"]]
  end  

end
