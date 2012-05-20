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
  end
end
