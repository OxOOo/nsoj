class CreateBannedIds < ActiveRecord::Migration
  def change
    create_table :banned_ids do |t|
      t.datetime :deadline, null: false
      
      t.references :banned
      t.references :user

      t.timestamps null: false
    end
  end
end
