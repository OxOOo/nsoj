class CreateLanguages < ActiveRecord::Migration
  	def change
    		create_table :languages do |t|
			t.string :name, limit: 20, null: false
			t.string :origin_cmd, limit: 60, null: false
			t.string :extra_cmd, limit: 60

      			t.timestamps null: false
    		end
  	end
end
