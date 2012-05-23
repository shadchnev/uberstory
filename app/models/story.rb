class Story < ActiveRecord::Base
  
  has_many :lines
  has_many :users, :through => :lines
  
  accepts_nested_attributes_for :lines, :allow_destroy => true
  attr_accessible :lines_attributes
  
  def user
    lines.first.user unless lines.empty?
  end
  
  def involves?(user)
    users.include?(user) || users.any? {|u| u.friends.include?(user) }
  end
    
end
