class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid # facebook uid
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :profile_url
      t.string :image
      t.timestamps
    end
    
    add_index :users, :uid, :unique => true
    add_index :users, :email, :unique => true
    
  end
end
