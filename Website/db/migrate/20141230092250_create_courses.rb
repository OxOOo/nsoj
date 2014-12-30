class CreateCourses < ActiveRecord::Migration
  	def change
    		create_table :courses do |t|
			t.string :name, null: false
			t.text :description, limit: 1010, null:false
			t.references :user

      			t.timestamps null: false
    		end
  	end
end
