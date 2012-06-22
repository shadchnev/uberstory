class Score < ActiveRecord::Base
  attr_accessible :event, :target_id, :user_id, :value
  
  belongs_to :user
  
end
