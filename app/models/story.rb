class Story < ActiveRecord::Base
  
  has_many :lines
  has_many :users, :through => :lines
  
  accepts_nested_attributes_for :lines, :allow_destroy => true
  attr_accessible :lines_attributes
  
  def user
    lines.first.user unless lines.empty?
  end
  
  def involves?(user)
    !((user.friends.map{|f| f.uid } + [user.uid]) & users.map{|u| u.uid}).empty?
  end
  
  def last_line_by(user)
    lines.last.user.id == user.id
  end
  
end
