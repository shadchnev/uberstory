module Rules
  
  class ScoreForNewLine < Rule
    
    NEW_LINE_REWARD = 10
  
    def self.activator
      'line.added'
    end
    
    def self.evaluate(event, payload)      
      return unless apply_to?(event, payload)
      add_score(NEW_LINE_REWARD, event, payload)
    end
    
  end
  
end