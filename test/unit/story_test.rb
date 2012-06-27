require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  test "the story length" do
    story = Story.new
    assert story.valid?
    u = User.create    
    story.send(:max_length).times do
      story.lines << Line.new(:text => "hello")
      story.lines.last.user = User.create
    end
    assert story.valid?
    story.lines << Line.new(:text => "hello")
    story.lines.last.user = User.create
    assert !story.valid?
  end
end
