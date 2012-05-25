class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_current_user
    
  def graph
    @graph ||= Koala::Facebook::API.new(session[:fb_token])    
  end
  
  def set_current_user
    @current_user = current_user
  end

  def authenticate!    
    puts "forcing auth redirect"
    @redirect_url = '/auth/facebook'
    render "facebook/parent_redirect", :layout => false
  end

  def authenticate_if_necessary
    "authenticate_if_necessary"
    authenticate! unless user_signed_in?
  end
  
  def sign_in(user, token)
    raise "Need both a user (#{user.to_s}) and a token (#{token.to_s}) to sign in" unless user && token
    session[:fb_token] = token
    session[:user_id] = user.id
    puts "User #{session[:user_id]} signed in: #{session[:fb_token]}"
    true
  end
  
  def user_signed_in?
    puts "User signed in = #{!session[:user_id].blank?}"
    !session[:user_id].blank?
  end
  
  def current_user
    return unless user_signed_in?
    user = User.find(session[:user_id])
    user.token = session[:fb_token]
    user
  end

end
