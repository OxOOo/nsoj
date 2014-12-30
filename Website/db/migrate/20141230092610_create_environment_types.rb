class CreateEnvironmentTypes < ActiveRecord::Migration
  	def change
    		create_table :environment_types do |t|
			t.string :name, limit: 30, null: false
			t.text :description, limit: 1010, null: false

      			t.timestamps null: false
    		end
  	end
end
