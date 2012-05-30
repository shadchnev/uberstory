module StoriesHelper
  
  def garbage(original)
    original.gsub(/\w/) { ('a'..'z').to_a[rand(26)] }
  end
  
  def can_add_new_line(user, story)
    # story.involves?(current_user) && !story.last_line_by?(user)
    story.writable_by user
  end
  
  def banter
    home_banter = [
      "Hey there Shakespeare!",
      "Hey #{current_user.first_name}! Feeling creative today?",
      "Once upon a time, #{current_user.first_name} started writing a story"
      ]
    home_banter[rand(home_banter.length)]
  end
  
    
end
