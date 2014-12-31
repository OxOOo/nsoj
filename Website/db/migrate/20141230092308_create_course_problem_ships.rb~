class CreateCourseProblemShips < ActiveRecord::Migration
  	def change
    		create_table :course_problem_ships do |t|
			t.references :user
			t.references :course
			t.references :problem

      			t.timestamps null: false
    		end
  	end
end
