class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string  :text, :limit => 140
      t.integer :story_id
      t.integer  :user_id
      t.timestamps
    end
  end
end
