class CreateUserCourseShips < ActiveRecord::Migration
  	def change
    		create_table :user_course_ships do |t|
			t.integer :status, defualt: 1, null: false
			t.integer :level, defualt: 0, null: false
			t.references :user
			t.references :course

      			t.timestamps null: false
    		end
  	end
end
