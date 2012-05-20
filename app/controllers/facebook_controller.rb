class FacebookController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => :init
  
  def init
    if user_signed_in?
      redirect_to "/stories"
    else
      @redirect_url = "/auth/facebook?signed_request=#{request.params['signed_request']}&state=canvas"
      render :parent_redirect
    end
  end
  
  def authenticated
    user = User.find_or_create_by_fb_auth(request.env['omniauth.auth'])
    sign_in user, request.env['omniauth.auth'][:credentials][:token]    
    @redirect_url = "http://apps.facebook.com/uberstory"
    render :parent_redirect
  end
  
end
