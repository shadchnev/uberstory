module StoriesHelper
  
  def garbage(original)
    original.gsub(/\w/) { ('a'..'z').to_a[rand(26)] }
  end
  
  def can_add_new_line(user, story)
    story.involves?(current_user) && !story.last_line_by?(user)
  end
    
end
