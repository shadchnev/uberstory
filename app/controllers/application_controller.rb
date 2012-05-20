class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_current_user
  
  def set_current_user
    @current_user = current_user
    @current_user.token = token
  end

  def token
    session[:fb_token]
  end
  
  def authenticate!
    redirect_to '/auth/facebook'
  end
  
  def sign_in(user, token)
    session[:fb_token] = token
    session[:user_id] = user.id
  end
  
  def user_signed_in?
    !!session[:user_id]
  end
  
  def current_user
    User.find(session[:user_id]) if user_signed_in?
  end

end
