module StoriesHelper
  
  def garbage(original)
    original.gsub(/\w/) { ('a'..'z').to_a[rand(26)] }
  end
  
end
