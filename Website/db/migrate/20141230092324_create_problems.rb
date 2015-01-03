class CreateProblems < ActiveRecord::Migration
  	def change
    		create_table :problems do |t|
			t.string :name, limit: 60, null: false
			t.integer :environment, default: 0, null: false
			t.integer :answer_limit, default: 0, null: false
			t.integer :time_limit, default: 0, null: false
			t.integer :memory_limit, default: 0,null: false
			t.string :origin_id, limit: 30,default: "0", null: false
			t.boolean :hide, default: false, null: false
			t.integer :task, default: 0, null: false
			t.references :user
			t.references :online_judge
			t.references :problem_type

      			t.timestamps null: false
    		end
  	end
end
