require 'test_helper'
require 'mocha'

class GamificationTest < ActiveSupport::TestCase
  
  include Rules
  
  def test_add_score_for_a_line
    user = User.create
    story = Story.new
    story.lines << Line.new(:text => "Hello!")
    story.lines.first.user = user
    story.save!
    event = 'line.added'
    payload = {:user_id => user.id, :target_id => story.lines.last.id}
    rules = Rule.filter(event, payload) 
    rule = rules.select{|r| r == :ScoreForNewLine }.first
    assert_equal 0, user.score
    CheckRuleJob.new(rule, event, payload).perform
    assert_equal 1, user.reload.score
  end
    
  def test_give_a_badge_for_three_abandoned_stories
    user = User.create
    3.times do      
      story = Story.new
      story.lines << Line.new(:text => "Hi!")
      story.lines.first.user = user
      story.save!
    end
    Story.any_instance.stubs("abandoned?").returns(true)
    event = 'timer'
    payload = {:user_id => user.id}
    assert_equal 0, user.badges.count
    CheckRuleJob.new(:TumbleweedBadge, event, payload).perform
    assert_equal 1, user.reload.badges.count
  end
    
end
