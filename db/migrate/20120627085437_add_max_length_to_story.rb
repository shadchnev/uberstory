class AddMaxLengthToStory < ActiveRecord::Migration
  def change
    add_column :stories, :max_length, :integer
  end
end
