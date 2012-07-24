# Understands how to interact with Facebook redirections
class FacebookController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => :init
  skip_before_filter :sign_in_user, :only => [:authenticated, :host_redirect]
  
  def host_redirect
    query_string = "/?story_id=#{params[:story_id]}" if params[:story_id]
    @redirect_url = Rails.configuration.host_url + query_string.to_s
    puts "Host redirect to #{@redirect_url}"
    render :parent_redirect, :layout => false
  end
  
  def init
    remove_all_requests # push to the bg!
    # redirect_to redirect_url || stories_url
    redirect_to redirect_url || canvas_url
  end
  
  def authenticated
    puts request.env.inspect
    User.find_or_create_by_fb_auth(request.env['omniauth.auth'])    
    redirect_to host_url(:story_id => request.env['omniauth.params']["story_id"])    
  end
  
private
  
  # After the user clicks on a request, it's the app's responsibility to delete the request
  def remove_all_requests
    return if params[:request_ids].blank?
    requests = params[:request_ids].split(',')
    requests.each do |request|
      current_user.delete_request(request)
    end
  end
  
end
