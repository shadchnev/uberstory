# Understands how to interact with Facebook redirections
class FacebookController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => :init
  
  def host_redirect
    @redirect_url = Rails.configuration.host_url
    render :parent_redirect, :layout => false
  end
  
  def init
    token, user_id = extract_token_and_user_id
    authenticate! and return unless token
    user = User.find_by_uid(user_id)
    sign_in user, token
    remove_all_requests
    redirect_to "/stories"
  end
  
  def authenticated
    user = User.find_or_create_by_fb_auth(request.env['omniauth.auth'])
    sign_in user, request.env['omniauth.auth'][:credentials][:token]    
    redirect_to host_url
  end
  
private

  def extract_token_and_user_id
    return unless params[:signed_request]
    @oauth = Koala::Facebook::OAuth.new(Rails.configuration.facebook_app_id, Rails.configuration.facebook_app_secret)
    @signed_request = @oauth.parse_signed_request(params[:signed_request]) 
    [@signed_request["oauth_token"], @signed_request["user_id"]]
  end
  
  # After the user clicks on a request, it's the app's responsibility to delete the request
  def remove_all_requests
    return if params[:request_ids].blank?
    requests = params[:request_ids].split(',')
    requests.each do |request|
      graph.delete_object("#{request}_#{current_user.uid}")
    end
  end
  
end
