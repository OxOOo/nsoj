class CreateOnlineJudges < ActiveRecord::Migration
  	def change
    		create_table :online_judges do |t|
			t.string :name, limit: 30, null: false
			t.text :description, limit: 1010, null: false
			t.string :address, limit: 50, null: false
			t.string :regexp, limit: 30, null: false
			t.string :hint, limit: 30

      			t.timestamps null: false
    		end
  	end
end
