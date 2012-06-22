class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :value
      t.integer :target_id
      t.string :event
      t.integer :user_id

      t.timestamps
    end
  end
end
