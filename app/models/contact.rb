class Contact < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :message
  validates_length_of :message, :maximum => 500
  
  attr_accessible :message
  
end
