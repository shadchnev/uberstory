class UsersController < ApplicationController

  def leaders
    render :json => current_user.leaders
  end

end
