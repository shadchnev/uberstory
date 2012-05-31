class StaticController < ApplicationController  
  
  skip_before_filter :sign_in_user
  
end