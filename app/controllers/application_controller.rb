class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_current_user
    
  def graph
    @graph ||= Koala::Facebook::API.new(session[:fb_token])    
  end
  
  def set_current_user
    @current_user = current_user
  end

  def authenticate_if_necessary
    redirect_to '/auth/facebook' unless user_signed_in?
  end
  
  def sign_in(user, token)
    raise "Need both a user (#{user.to_s}) and a token (#{token.to_s}) to sign in" unless user && token
    session[:fb_token] = token
    session[:user_id] = user.id
  end
  
  def user_signed_in?
    !!session[:user_id]
  end
  
  def current_user
    return unless user_signed_in?
    user = User.find(session[:user_id]) 
    user.token = session[:fb_token]
    user
  end

end
