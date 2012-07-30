class CreateInviteesStories < ActiveRecord::Migration
  def change
    create_table :invitees_stories, :id => false do |t|
      t.integer :invitee_id
      t.integer :story_id
    end
  end

end
