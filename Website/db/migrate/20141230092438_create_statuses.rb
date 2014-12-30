class CreateStatuses < ActiveRecord::Migration
  	def change
    		create_table :statuses do |t|
			t.string :name, limit: 30, null: false
			t.string :style, limie: 30

      			t.timestamps null: false
    		end
  	end
end
