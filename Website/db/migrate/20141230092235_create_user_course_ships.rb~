class CreateUserCourseShips < ActiveRecord::Migration
  	def change
    		create_table :user_course_ships do |t|
			t.integer :status, default: 1, null: false
			t.integer :level, default: 0, null: false
			t.references :user
			t.references :course
			t.integer :solved_count, default: 0, null: false
			t.integer :accepted_count, default: 0, null: false
			t.integer :submissions_count, default: 0, null: false

      			t.timestamps null: false
    		end
  	end
end
