class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :name
      t.integer :target_id
      t.string :event
      t.integer :user_id

      t.timestamps
    end
    
    add_index :badges, [:name, :user_id], :unique => true
    
  end
end
