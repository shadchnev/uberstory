class Line < ActiveRecord::Base
  
  belongs_to :story
  belongs_to :user
  attr_accessible :text
  
  validates_presence_of :user
  validates_presence_of :text
  
  def visible_to?(user)
    last_line_by_user = story.lines.find_all_by_user_id(user.id).last
    return story.lines.last == self if last_line_by_user.nil?
    (created_at <= last_line_by_user.created_at) || story.lines.last == self
  end
    
end
