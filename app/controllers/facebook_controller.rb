# Understands how to interact with Facebook redirections
class FacebookController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => :init
  skip_before_filter :sign_in_user, :only => [:authenticated, :host_redirect]
  
  def host_redirect
    @redirect_url = Rails.configuration.host_url
    render :parent_redirect, :layout => false
  end
  
  def init
    remove_all_requests
    redirect_to redirect_url || stories_url
  end
  
  def authenticated
    user = User.find_or_create_by_fb_auth(request.env['omniauth.auth'])
    redirect_to request.env['omniauth.origin'] || host_url
  end
  
private
  
  # After the user clicks on a request, it's the app's responsibility to delete the request
  def remove_all_requests
    return if params[:request_ids].blank?
    requests = params[:request_ids].split(',')
    requests.each do |request|
      current_user.graph.delete_object("#{request}_#{current_user.uid}") rescue nil
    end
  end
  
end
