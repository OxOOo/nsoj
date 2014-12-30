class CreateProblems < ActiveRecord::Migration
  	def change
    		create_table :problems do |t|
			t.string :name, limit: 60, null: false
			t.integer :environment, defualt: 0, null: false
			t.integer :source_limit, defualt: 0, null: false
			t.integer :time_limit, defualt: 0, null: false
			t.integer :memory_limit, defualt: 0,null: false
			t.string :origin_id, limit: 30,defualt: "0", null: false
			t.integer :task, defualt: 0, null: false
			t.references :user
			t.references :online_judge
			t.references :problem_type

      			t.timestamps null: false
    		end
  	end
end
