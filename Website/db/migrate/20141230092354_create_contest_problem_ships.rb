class CreateContestProblemShips < ActiveRecord::Migration
  	def change
    		create_table :contest_problem_ships do |t|
			t.references :contest
			t.references :problem

      			t.timestamps null: false
    		end
  	end
end
