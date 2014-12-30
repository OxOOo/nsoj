class CreateBannedIds < ActiveRecord::Migration
  	def change
    		create_table :banned_ids do |t|
			t.integer :banned_id, null: false
			t.datetime :deadline, null: false
			t.references :user

      			t.timestamps null: false
    		end
  	end
end
