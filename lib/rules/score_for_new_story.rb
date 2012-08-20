module Rules
  
  class ScoreForNewStory < Rule
    
    NEW_STORY_REWARD = 25
  
    def self.activator
      'story.added'
    end
    
    def self.evaluate(event, payload)
      puts "EVALUATING story.added"
      return unless apply_to?(event, payload)
      add_score(NEW_STORY_REWARD, event, payload)
      puts '+25'
    end
    
  end
  
end