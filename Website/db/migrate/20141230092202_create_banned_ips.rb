class CreateBannedIps < ActiveRecord::Migration
  	def change
    		create_table :banned_ips do |t|
			t.string :banned_ip, limit: 30, null: false
			t.datetime :deadline, null: false
			t.references :user

      			t.timestamps null: false
    		end
  	end
end
