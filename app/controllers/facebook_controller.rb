# Understands how to interact with Facebook redirections
class FacebookController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => :init
  
  def parent_redirect
    render :layout => false
  end
  
  def init
    token = nil
    if params[:signed_request]
      @oauth = Koala::Facebook::OAuth.new(Rails.configuration.facebook_app_id, Rails.configuration.facebook_app_secret)
      @signed_request = @oauth.parse_signed_request(params[:signed_request]) 
      token = @signed_request["oauth_token"]
    end
    if token
      user = User.find_by_uid(@signed_request["user_id"])
      sign_in user, token
      remove_all_requests
      redirect_to "/stories"
    else
      @redirect_url = "/auth/facebook?signed_request=#{request.params['signed_request']}&state=canvas"
      render :parent_redirect
    end
  end
  
  def authenticated
    user = User.find_or_create_by_fb_auth(request.env['omniauth.auth'])
    sign_in user, request.env['omniauth.auth'][:credentials][:token]    
    # this line means if Rails.env.production? == true, then return the production url, otherwise return "/"
    @redirect_url = Rails.env.production? ? "http://apps.facebook.com/uberstory" : "http://apps.facebook.com/uberstory-dev"
    render :parent_redirect
  end
  
private
  
  # After the user clicks on a request, it's the app's responsibility to delete the request
  def remove_all_requests
    return if params[:request_ids].blank?
    requests = params[:request_ids].split(',')
    requests.each do |request|
      graph.delete_object("#{request}_#{current_user.uid}")
    end
  end
  
end
