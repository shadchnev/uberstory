class Badge < ActiveRecord::Base
  attr_accessible :event, :name, :target_id, :user_id
  
  belongs_to :user
  
end
