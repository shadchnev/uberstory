class Line < ActiveRecord::Base
  
  belongs_to :story
  belongs_to :user
  attr_accessible :text
  
  validates_presence_of :user
  validates_presence_of :text
  validates_length_of :text, :maximum => 140
  
  # def visible
  #   story.finished? || story.lines.last == self
  # end
      
end
