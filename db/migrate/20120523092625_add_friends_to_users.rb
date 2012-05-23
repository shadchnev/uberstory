class AddFriendsToUsers < ActiveRecord::Migration
  def change
    
    create_table :users_friends, :id => false do |t|
      t.integer :user_id
      t.integer :friend_id
    end
    
    add_index :users_friends, [:user_id, :friend_id], :unique => true
    
  end
end
