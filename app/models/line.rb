class Line < ActiveRecord::Base
  
  belongs_to :story
  belongs_to :user
  attr_accessible :text
  
  validates_presence_of :user
  validates_presence_of :text
  validates_length_of :text, :maximum => 140
  
  def visible_to?(user)
    last_line_by_user = story.lines.find_all_by_user_id(user.id).last
    (last_line_by_user and created_at <= last_line_by_user.created_at) || story.lines.last == self
  end
  
  def number
    story.lines.count(:conditions => ["id <= ?", id])
  end
    
end
