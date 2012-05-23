class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_current_user
  before_filter :set_app_id
    
  def set_app_id
    @app_id = ENV['APP_ID']
  end
  
  def graph
    @graph ||= Koala::Facebook::API.new(session[:fb_token])    
  end
  
  def set_current_user
    @current_user = current_user
  end

  def authenticate!
    redirect_to '/auth/facebook'
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
    puts "current user #{user.id} has token #{user.token}"
    user
  end

end
