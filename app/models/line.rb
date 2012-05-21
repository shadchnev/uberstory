class Line < ActiveRecord::Base
  
  belongs_to :story
  belongs_to :user
  attr_accessible :text
  
  validates_presence_of :user
  validates_presence_of :text
    
end
